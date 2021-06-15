import 'package:doctorme/screens/admin/citas/form.dart';
import 'package:doctorme/screens/common/navbar.dart';
import 'package:doctorme/services/cita_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'list.dart';

class CitasPage extends StatefulWidget {
  static String route = '/citas';

  const CitasPage({Key key}) : super(key: key);

  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  CitaService citaService = CitaService();

  DateTime _focusedDay;
  DateTime _selectedDay;
  bool expanded;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    var count = 2;
    if (MediaQuery.of(context).size.width < 700) {
      count = 1;
    }

    return Scaffold(
      appBar: adminNavbar(context),
      body: GridView.count(
        crossAxisCount: count,
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
          Column(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: Text("Agregar Cita")),
              Visibility(
                  visible: expanded,
                  child: CitaForm(
                    day: _selectedDay,
                    refreshDay: () {
                      setState(() {});
                    },
                  )),
              Expanded(
                child: CitaList(
                  day: _selectedDay,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
