import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final String email;
  RegisterPage({Key key, this.email}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  createAccount() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email, password: "Dr.Soler7788");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. Soler"),
      ),
      body: Container(
        child: Text("Bienvenido!! " + widget.email),
      ),
    );
  }
}
