import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr. Soler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _emailForm = GlobalKey<FormState>();
  var _codeForm = GlobalKey<FormState>();
  var authCode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. Soler"),
      ),
      body: authCode > 0 ? codeForm() : emailForm(),
    );
  }

  Form emailForm() {
    return Form(
      key: _emailForm,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (value) => value.isEmpty
                      ? "Correo Requerido"
                      : EmailValidator.validate(value)
                          ? null
                          : "Correo Incorrecto",
                  decoration: InputDecoration(labelText: "Email"),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    if (_emailForm.currentState.validate()) {
                      setState(() {
                        authCode = 3525;
                      });
                    }
                  },
                  child: Text("Entrar")),
            )
          ],
        ),
      ),
    );
  }

  Form codeForm() {
    return Form(
      key: _codeForm,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Revisa tu correo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 100,
                child: TextFormField(
                  validator: (value) =>
                      authCode > 0 && int.tryParse(value) == authCode
                          ? null
                          : "incorrecto",
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: "código",
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    if (_codeForm.currentState.validate()) {
                      print("Vamonos!!!");
                    }
                  },
                  child: Text("Entrar")),
            )
          ],
        ),
      ),
    );
  }
}
