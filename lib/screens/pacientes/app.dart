import 'package:flutter/material.dart';

import 'home.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({Key key}) : super(key: key);

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
