import 'package:doctorme/models/profile.dart';
import 'package:doctorme/screens/account/details.dart';
import 'package:doctorme/screens/common/navbar.dart';
import 'package:doctorme/services/profile_service.dart';
import 'package:flutter/material.dart';

class PatientsPage extends StatefulWidget {
  static String route = 'patients';

  const PatientsPage({Key key}) : super(key: key);

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: adminNavbar(context),
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(hintText: "Buscar"),
                ),
                Expanded(
                  child: Rows(
                    text: searchController.text,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class Rows extends StatelessWidget {
  final _profileService = ProfileService();

  final String text;

  Rows({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _profileService.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        List<Profile> patients = snapshot.data;
        if (patients == null || patients.isEmpty) {
          return Text("No hay ningun paciente registrado");
        }

        if (text.isNotEmpty) {
          var t = text.toLowerCase();
          patients = patients
              .where((p) =>
                  p.fullname().toLowerCase().contains(t) ||
                  p.email.contains(t) ||
                  p.phone.contains(t))
              .toList();
        }

        return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, idx) {
              var p = patients[idx];
              return TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UserDetailsPage(email: p.email))),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.fullname(),
                            ),
                            Text(p.email),
                            Text(p.phone),
                            Text(p.formattedBirthDate())
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
