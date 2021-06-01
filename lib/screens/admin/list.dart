import 'package:doctorme/screens/account/user_details.dart';
import 'package:doctorme/services/cita_service.dart';
import 'package:doctorme/models/cita.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CitaList extends StatefulWidget {
  final DateTime day;

  CitaList({Key key, this.day}) : super(key: key);

  @override
  _CitaListState createState() => _CitaListState();
}

class _CitaListState extends State<CitaList> {
  final citaService = CitaService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: citaService.getByDay(widget.day),
        builder: (context, snapshot) {
          List<Cita> citas = snapshot.data;

          if (citas == null || citas.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "No hay citas",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
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
                  leading: Text(c.turn > 0 ? c.turn.toString() : ""),
                  title: Center(
                      child: TextButton(
                    child: Text(c.email),
                    onPressed: c.profile == null
                        ? null
                        : () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return UserDetailsPage(
                                email: c.email,
                              );
                            })),
                  )),
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
