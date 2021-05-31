import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorme/services/profile_service.dart';

import '../models/cita.dart';

class CitaService {
  final profileService = ProfileService();

  Future<void> create(String email, DateTime day) async {
    try {
      var citas = await getByDay(day);
      var turn = 1;

      citas.forEach((element) => turn = max(element.turn + 1, turn));

      await FirebaseFirestore.instance.collection('citas').add(
          {'email': email, 'day': day, 'turn': turn, 'status': 'pendiente'});
    } catch (e) {
      print(e);
    }
  }

  Future<List<Cita>> getByEmail(String email) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('citas')
          .where('email', isEqualTo: email)
          .get();

      List<Cita> citas = [];
      snapshot.docs.forEach((element) {
        citas.add(Cita.fromSnapshot(element));
      });

      citas.sort((a, b) => b.day.compareTo(a.day));

      return citas;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> cancel(Cita cita) async {
    try {
      await FirebaseFirestore.instance
          .doc(cita.reference.path)
          .update({'status': 'cancelado', 'turn': 0});

      await updateCitasAfterTurn(cita.day, cita.turn);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Cita>> getByDay(DateTime day) async {
    try {
      var nextDay = day.add(Duration(days: 1));
      var snapshot = await FirebaseFirestore.instance
          .collection('citas')
          .where('day', isGreaterThanOrEqualTo: day, isLessThan: nextDay)
          .get();

      List<Cita> citas = [];
      List<Future> futures = [];

      snapshot.docs.forEach((element) => futures.add(Future(() async {
            var c = Cita.fromSnapshot(element);
            c.profile = await profileService.get(email: c.email);
            citas.add(c);
          })));

      await Future.wait(futures);

      citas.sort((a, b) => a.turn.compareTo(b.turn));

      return citas;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateCitasAfterTurn(DateTime day, int turn) async {
    try {
      var dbCitas = await getByDay(day);
      List<Cita> citas = [];

      dbCitas.forEach((c) {
        if (c.turn >= turn) {
          citas.add(c);
        }
      });
      // Organizar por turno
      citas.sort((a, b) => b.turn.compareTo(a.turn));

      List<Future> futures = [];

      citas.forEach((element) {
        futures.add(FirebaseFirestore.instance
            .doc(element.reference.path)
            .update({'turn': turn}));
        turn++;
      });

      // Nos fuimo!!!
      await Future.wait(futures);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
