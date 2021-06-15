import 'package:doctorme/screens/admin/citas.dart';
import 'package:doctorme/screens/admin/patients.dart';
import 'package:doctorme/screens/common/navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String route = '/';

  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminNavbar(context),
      body: Column(
        children: [
          TextButton(
              onPressed: () => Navigator.pushNamed(context, CitasPage.route),
              child: Text("Citas")),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, PatientsPage.route),
              child: Text("Pacientes")),
        ],
      ),
    );
  }
}
