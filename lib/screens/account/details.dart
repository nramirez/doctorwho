import 'package:doctorme/screens/account/user.dart';
import 'package:doctorme/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

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
                  return UserPage(profile: snapshot.data);
                })));
  }
}
