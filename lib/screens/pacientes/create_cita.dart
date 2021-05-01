import 'package:doctorme/services/cita_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateCita extends StatefulWidget {
  const CreateCita({Key key}) : super(key: key);

  @override
  _CreateCitaState createState() => _CreateCitaState();
}

class _CreateCitaState extends State<CreateCita> {
  CitaService citaService = CitaService();

  DateTime _focusedDay;
  DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. Soler"),
      ),
      body: Column(
        children: [
          TableCalendar(
              locale: 'es_ES',
              headerStyle:
                  HeaderStyle(titleCentered: true, formatButtonVisible: false),
              selectedDayPredicate: (day) => _selectedDay == day,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                });
              },
              focusedDay: _focusedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 300))),
          TextButton(
              onPressed: () async {
                await citaService.create(
                    FirebaseAuth.instance.currentUser.email, _selectedDay);
                Navigator.pop(context);
              },
              child: Text("Agendar"))
        ],
      ),
    );
  }
}
