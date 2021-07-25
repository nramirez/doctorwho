import 'package:doctorme/utils/auth_builder.dart';

import '../env.dart';

class AppState {
  UserDetails currentUser;

  bool isAdmin() {
    if (currentUser == null) {
      return false;
    }

    return isSuperAdmin(currentUser.user.email) ||
        currentUser.profile.isAdmin();
  }

  bool isSuperAdmin(email) => [Env().superAdmin].contains(email);
}
