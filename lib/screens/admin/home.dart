import 'package:doctorme/screens/admin/citas/index.dart';
import 'package:doctorme/screens/admin/patients/list.dart';
import 'package:doctorme/screens/common/navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String route = '/';

  const HomePage({Key key}) : super(key: key);

  Widget iconPage({context, route, description, icon}) {
    return TextButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Card(
          child: SizedBox(
            width: 100,
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Icon(icon), Text(description)],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminNavbar(context),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconPage(
                context: context,
                route: CitasPage.route,
                description: "Citas",
                icon: Icons.calendar_today_outlined),
            iconPage(
                context: context,
                route: PatientsPage.route,
                description: "Pacientes",
                icon: Icons.people),
          ],
        ),
      ),
    );
  }
}
