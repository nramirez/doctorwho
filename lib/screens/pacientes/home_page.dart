import 'package:doctorme/screens/account/user_details.dart';
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
        title: Text("Citas"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserDetailsPage(
                            email: FirebaseAuth.instance.currentUser.email,
                          ))),
              icon: Icon(Icons.person))
        ],
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
