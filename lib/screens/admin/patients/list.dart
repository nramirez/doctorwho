import 'package:doctorme/screens/common/navbar.dart';
import 'package:flutter/material.dart';

class PatientsPage extends StatelessWidget {
  static String route = 'patients';

  const PatientsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminNavbar(context),
      body: Center(
        child: Text("Lista de Pacientes"),
      ),
    );
  }
}
