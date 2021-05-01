import 'package:flutter/material.dart';

import 'home.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dr. Soler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {'/': (context) => HomePage()},
    );
  }
}
