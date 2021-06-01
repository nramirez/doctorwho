import 'dart:async';

import 'package:doctorme/screens/account/register.dart';
import 'package:doctorme/services/phone_service.dart';
import 'package:doctorme/services/profile_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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

  final errorController = StreamController<ErrorAnimationType>();

  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. Soler"),
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          child: authCode > 999 ? codeForm() : emailForm(),
        ),
      ),
    );
  }

  Form emailForm() {
    return Form(
      key: _loginForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: "Email o Telefono"),
            controller: _emailorPhoneController,
            validator: (value) => value.isEmpty
                ? "campo requerido"
                : authCode == 0
                    ? "valor incorrecto"
                    : null,
          ),
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
    );
  }

  Form codeForm() {
    return Form(
      key: _codeForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Verfica el codigo que te enviamos",
            ),
          ),
          PinCodeTextField(
            appContext: context,
            length: 4,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveColor: Colors.blue),
            animationDuration: Duration(milliseconds: 300),
            errorAnimationController: errorController,
            onCompleted: (v) async {
              if (v != authCode.toString()) {
                setState(() {
                  _hasError = true;
                  errorController.add(ErrorAnimationType.shake);
                });
              } else {
                if (_codeForm.currentState.validate()) {
                  var email = isEmail(_emailorPhoneController.text)
                      ? _emailorPhoneController.text
                      : null;
                  var phone = isEmail(_emailorPhoneController.text)
                      ? null
                      : _emailorPhoneController.text;
                  var superPassword = "Dr.Soler7788";
                  var perfil =
                      await ProfileService().get(email: email, phone: phone);

                  if (perfil == null) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return new RegisterPage(
                        email: email,
                        phone: phone,
                      );
                    }));
                  } else {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: perfil.email, password: superPassword);
                  }
                }
              }
            },
            onChanged: (value) {
              setState(() {
                //currentText = value;
              });
            },
            beforeTextPaste: (text) {
              return true;
            },
          ),
          Visibility(
              visible: _hasError == true,
              child: Text(
                "Codigo incorrecto",
                style: TextStyle(color: Colors.red),
              )),
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
    );
  }

  bool isEmail(String text) => EmailValidator.validate(text);
}
