import 'package:doctorme/screens/admin/app.dart';
import 'package:doctorme/screens/common/loading.dart';
import 'package:doctorme/screens/pacientes/app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_strategy/url_strategy.dart';

import 'login.dart';

Future main() async {
  await DotEnv.load(fileName: ".env");
  // Here we set the URL strategy for our web app.
  // It is safe to call this function when running on mobile or desktop as well.
  setPathUrlStrategy();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<User>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.data == null &&
                      FirebaseAuth.instance.currentUser == null) {
                    return LoginApp();
                  }
                  var user = FirebaseAuth.instance.currentUser;

                  if (isAdmin(user.email)) {
                    return AdminApp();
                  }

                  return HomeApp();
                });
          }

          return LoadingPage();
        });
  }
}

bool isAdmin(email) => ["hola@doctor.com", "secre@doctor.com"].contains(email);
