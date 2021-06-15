import 'package:doctorme/screens/admin/home.dart';
import 'package:doctorme/screens/admin/patients.dart';
import 'package:flutter/material.dart';

import 'citas.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Para navegacion mas compleja ver:
    // https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dr. Soler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        HomePage.route: (context) => HomePage(),
        CitasPage.route: (context) => CitasPage(),
        PatientsPage.route: (context) => PatientsPage(),
      },
    );
  }
}
