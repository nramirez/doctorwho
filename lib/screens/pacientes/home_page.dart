import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cita_list.dart';
import 'create_cita.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () => FirebaseAuth.instance.signOut(),
        ),
        title: Text("Citas"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                  onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateCita()))
                          .then((value) {
                        setState(() {});
                      }),
                  child: Text("Agendar Cita")),
              Expanded(child: CitaList())
            ],
          ),
        ),
      ),
    );
  }
}
