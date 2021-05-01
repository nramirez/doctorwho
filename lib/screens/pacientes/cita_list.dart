import 'package:doctorme/services/cita_service.dart';
import 'package:doctorme/models/cita.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CitaList extends StatefulWidget {
  CitaList({Key key}) : super(key: key);

  @override
  _CitaListState createState() => _CitaListState();
}

class _CitaListState extends State<CitaList> {
  final citaService = CitaService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: citaService.getByEmail(FirebaseAuth.instance.currentUser.email),
        builder: (context, snapshot) {
          List<Cita> citas = snapshot.data;

          if (citas == null || citas.length == 0) {
            return Container(
              child: Text(
                "No tiene citas",
                style: TextStyle(color: Colors.orange),
              ),
            );
          }

          return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, idx) {
                Cita c = citas[idx];
                return ListTile(
                  tileColor:
                      c.isCancelled() ? Colors.red[100] : Colors.grey[100],
                  leading: Text(c.turn.toString()),
                  title: Center(child: Text(c.formattedDay())),
                  subtitle: Center(child: Text(c.status)),
                  trailing: c.isCancelled()
                      ? IconButton(
                          mouseCursor: MouseCursor.uncontrolled,
                          icon: Icon(Icons.close_outlined),
                          onPressed: null)
                      : IconButton(
                          icon: Icon(Icons.close_outlined),
                          onPressed: () async {
                            await citaService.cancel(c);
                            setState(() {});
                          }),
                );
              });
        });
  }
}
