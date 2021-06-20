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
  Map<String, int> appts = Map<String, int>();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    expanded = false;
    if (appts.isEmpty) {
      loadAppts(_selectedDay);
    }
  }

  Future loadAppts(DateTime from) async {
    appts.addAll(await citaService.getApptsCount(from: from));
    setState(() {});
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
            lastDay: DateTime.now().add(Duration(days: 300)),
            calendarBuilders: CalendarBuilders(
              todayBuilder: (context, day, focusedDay) => Center(
                child: Text(day.day.toString()),
              ),
              markerBuilder: (context, day, events) {
                var key = "${day.day}/${day.month}/${day.year}";
                var count = appts.containsKey(key) ? appts[key] : 0;

                if (count == 0) {
                  return null;
                }

                return Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.cyan),
                    child: Text(
                      count.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            onPageChanged: (focusedDay) async {
              _focusedDay = focusedDay;
              await loadAppts(focusedDay);
            },
          ),
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
