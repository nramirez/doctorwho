import 'package:doctorme/screens/account/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

AppBar adminNavbar(context) {
  return AppBar(
    title: Text("Admin"),
    actions: [
      IconButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => UserDetailsPage(
                        email: FirebaseAuth.instance.currentUser.email,
                      ))),
          icon: Icon(Icons.person))
    ],
  );
}
