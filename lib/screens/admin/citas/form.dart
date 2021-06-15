import 'package:doctorme/services/cita_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CitaForm extends StatefulWidget {
  final DateTime day;
  final Function refreshDay;

  CitaForm({Key key, this.day, this.refreshDay}) : super(key: key);

  @override
  _CitaFormState createState() => _CitaFormState();
}

class _CitaFormState extends State<CitaForm> {
  var _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _citaService = CitaService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 400,
        child: ListTile(
          title: TextFormField(
            controller: _emailController,
            validator: (value) => value.isEmpty
                ? "Correo Requerido"
                : EmailValidator.validate(value)
                    ? null
                    : "Correo Incorrecto",
          ),
          trailing: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await _citaService.create(_emailController.text, widget.day);
                  _emailController.clear();
                }
                widget.refreshDay();
              }),
        ),
      ),
    );
  }
}
