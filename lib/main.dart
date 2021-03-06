import 'package:doctorme/screens/admin/app.dart';
import 'package:doctorme/screens/common/loading.dart';
import 'package:doctorme/screens/pacientes/app.dart';
import 'package:doctorme/utils/app_state.dart';
import 'package:doctorme/utils/auth_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'login.dart';

Future main() async {
  await DotEnv.load(fileName: ".env");
  await initializeDateFormatting();
  // Here we set the URL strategy for our web app.
  // It is safe to call this function when running on mobile or desktop as well.
  setPathUrlStrategy();

  runApp(Provider(
    create: (context) => AppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<UserDetails>(
                stream: AuthStream().authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return LoginApp();
                  }
                  var details = snapshot.data;
                  context.watch<AppState>().currentUser = details;

                  if (details.isAdmin()) {
                    return AdminApp();
                  }

                  return HomeApp();
                });
          }

          return LoadingPage();
        });
  }
}
