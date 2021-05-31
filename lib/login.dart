import 'package:doctorme/screens/account/register.dart';
import 'package:doctorme/services/phone_service.dart';
import 'package:doctorme/services/profile_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'services/email_service.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final emailService = EmailService();
  final phoneService = PhoneService();
  var _loginForm = GlobalKey<FormState>();
  var _codeForm = GlobalKey<FormState>();
  var _emailorPhoneController = TextEditingController();
  var authCode = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. Soler"),
      ),
      body: authCode > 999 ? codeForm() : emailForm(),
    );
  }

  Form emailForm() {
    return Form(
      key: _loginForm,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: InputDecoration(hintText: "Email o Telefono"),
                  controller: _emailorPhoneController,
                  validator: (value) => value.isEmpty
                      ? "campo requerido"
                      : authCode == 0
                          ? "valor incorrecto"
                          : null,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () async {
                    if (_loginForm.currentState.validate()) {
                      var code;
                      if (isEmail(_emailorPhoneController.text)) {
                        code = await emailService
                            .sendSignInCode(_emailorPhoneController.text);
                      } else {
                        code = await phoneService
                            .sendSignInCode(_emailorPhoneController.text);
                      }
                      setState(() {
                        authCode = code;
                        _loginForm.currentState.validate();
                        print(code);
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
                      authCode > 999 && int.tryParse(value) == authCode
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
                  onPressed: () async {
                    if (_codeForm.currentState.validate()) {
                      var superPassword = "Dr.Soler7788";
                      var perfil = await ProfileService()
                          .get(_emailorPhoneController.text);

                      if (perfil == null) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          var email = isEmail(_emailorPhoneController.text)
                              ? _emailorPhoneController.text
                              : null;
                          var phone = isEmail(_emailorPhoneController.text)
                              ? null
                              : _emailorPhoneController.text;

                          return new RegisterPage(
                            email: email,
                            phone: phone,
                          );
                        }));
                      } else {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailorPhoneController.text,
                            password: superPassword);
                      }
                    }
                  },
                  child: Text("Entrar")),
            ),
            TextButton(
                onPressed: () async {
                  var code = await emailService
                      .sendSignInCode(_emailorPhoneController.text);
                  setState(() {
                    authCode = code;
                    print(code);
                  });
                },
                child: Text(
                  "Enviar otro codigo",
                  style: TextStyle(fontSize: 10),
                ))
          ],
        ),
      ),
    );
  }

  bool isEmail(String text) => EmailValidator.validate(text);
}
