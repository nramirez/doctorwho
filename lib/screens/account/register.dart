import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class RegisterPage extends StatefulWidget {
  final String email;
  RegisterPage({Key key, this.email}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String gender = "Sexo";
  final _formKey = GlobalKey<FormState>();

  createAccount() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email, password: "Dr.Soler7788");
  }

  Widget textbox(String description) {
    return TextFormField(
      validator: (value) => value.isEmpty ? "campo requerido" : null,
      decoration: InputDecoration(hintText: description),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dr. Soler"),
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                          "Hola! Para poder programar tu cita necesitamos saber un poco mas de ti"),
                    ),
                    Divider(),
                    textbox("nombre"),
                    textbox("apellido"),
                    textbox("telefono"),
                    DropdownButtonFormField(
                        validator: (value) =>
                            value == "Sexo" ? "campo requerido" : null,
                        onChanged: (String v) {
                          setState(() {
                            gender = v;
                          });
                        },
                        value: gender,
                        items: ["Sexo", "Femenino", "Masculino", "Otro"]
                            .map((v) => DropdownMenuItem(
                                  child: Text(v),
                                  value: v,
                                ))
                            .toList()),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text("fecha de nacimiento"),
                    ),
                    DatePickerWidget(
                      initialDate:
                          DateTime.now().add(Duration(days: -(365 * 18))),
                      lastDate: DateTime.now().add(Duration(days: -1)),
                      firstDate:
                          DateTime.now().add(Duration(days: -(365 * 150))),
                      dateFormat: "dd-MM-yyyy",
                      locale: DatePicker.localeFromString("es"),
                      pickerTheme: DateTimePickerTheme(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          dividerColor: Theme.of(context).primaryColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              print("Muy bien! Crear cuenta");
                            } else {
                              print("Error");
                            }
                          },
                          child: Text("Enviar")),
                    )
                  ],
                ),
              )),
        ));
  }
}
