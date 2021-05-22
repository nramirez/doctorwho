import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorme/models/profile.dart';

class ProfileService {
  get(String email) async {
    return null;
  }

  add(Profile perfil) async {
    try {
      var existente = await get(perfil.email);
      if (existente != null) {
        print("Usuario existente");
        return existente;
      }

      await FirebaseFirestore.instance
          .collection('profiles')
          .add(perfil.toJson());
    } catch (e) {
      print(e);
    }
  }
}
