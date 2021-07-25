import 'dart:async';

import 'package:doctorme/models/profile.dart';
import 'package:doctorme/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails {
  final Profile profile;
  final User user;

  UserDetails({this.profile, this.user});
}

class AuthStream {
  UserDetails currentUser;
  final ProfileService profileService = ProfileService();

  AuthStream() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        currentUser = null;
      } else {
        var profile = await profileService.get(email: user.email);

        if (profile == null) {
          currentUser = null;
          _controller.addError("El usuario no tiene perfil");
        }
        currentUser = UserDetails(user: user, profile: profile);
      }

      _controller.sink.add(currentUser);
    },
        onError: (e) => _controller.addError(e),
        onDone: () => _controller.close());
  }

  final StreamController<UserDetails> _controller =
      StreamController<UserDetails>();

  Stream<UserDetails> authStateChanges() => _controller.stream;
}
