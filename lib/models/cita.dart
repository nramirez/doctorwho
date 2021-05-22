import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorme/models/profile.dart';

class Cita {
  int turn;
  DateTime day;
  // Status
  // pendiente
  // cancelado
  String status;
  String email;
  DocumentReference reference;
  Profile profile;

  String formattedDay() => '${day.day}/${day.month}/${day.year}';

  Cita.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data.call(), reference: snapshot.reference);

  Cita.fromMap(Map<String, dynamic> map, {this.reference})
      : turn = map['turn'],
        day = map['day'].toDate(),
        status = map['status'],
        email = map['email'];

  bool isCancelled() => this.status == 'cancelado';
}
