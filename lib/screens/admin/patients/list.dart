import 'package:doctorme/models/profile.dart';
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
  ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: adminNavbar(context),
        body: FutureBuilder(
          future: _profileService.getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }

            List<Profile> patients = snapshot.data;
            Widget list;
            if (patients == null || patients.isEmpty) {
              list = Text("No hay ningun paciente registrado");
            } else {
              list = ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, idx) {
                    var p = patients[idx];
                    return Card(
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
                    );
                  });
            }

            return Center(
              child: SizedBox(width: 300, child: list),
            );
          },
        ));
  }
}
