import 'package:doctorme/models/profile.dart';
import 'package:doctorme/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class UserDetailsPage extends StatelessWidget {
  final String email;
  final ProfileService profileService = ProfileService();

  UserDetailsPage({Key key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dr. Soler"),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => FirebaseAuth.instance.signOut(),
            )
          ],
        ),
        body: Center(
            child: FutureBuilder(
                future: profileService.get(email: email),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return CircularProgressIndicator();
                  }
                  return PatientPage(profile: snapshot.data);
                })));
  }
}

class PatientPage extends StatefulWidget {
  final Profile profile;
  PatientPage({Key key, this.profile}) : super(key: key);

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  String gender = "Sexo";
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  DateTime birthdate;

  Widget textbox(String description, TextEditingController textController) {
    return TextFormField(
      controller: textController,
      validator: (value) => value.isEmpty ? "campo requerido" : null,
      decoration: InputDecoration(hintText: description),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.profile.name;
    lastnameController.text = widget.profile.lastname;
    gender = widget.profile.gender;
    birthdate = widget.profile.birthdate;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textbox("nombre", nameController),
              textbox("apellido", lastnameController),
              TextFormField(
                readOnly: true,
                initialValue: widget.profile.email,
                decoration: InputDecoration(hintText: "email"),
              ),
              TextFormField(
                readOnly: true,
                initialValue: widget.profile.phone,
                decoration: InputDecoration(hintText: "telefono"),
              ),
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
                initialDate: birthdate,
                lastDate: DateTime.now().add(Duration(days: -1)),
                firstDate: DateTime.now().add(Duration(days: -(365 * 150))),
                dateFormat: "dd-MM-yyyy",
                locale: DatePicker.localeFromString("es"),
                onChange: (value, selectedIndex) => birthdate = value,
                pickerTheme: DateTimePickerTheme(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    dividerColor: Theme.of(context).primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await ProfileService().update(Profile(
                            name: nameController.text,
                            lastname: lastnameController.text,
                            phone: widget.profile.phone,
                            gender: gender,
                            birthdate: birthdate,
                            email: widget.profile.email)
                          ..reference = widget.profile.reference);
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Actualizar")),
              )
            ],
          ),
        ));
  }
}
