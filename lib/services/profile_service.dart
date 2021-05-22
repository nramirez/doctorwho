import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorme/models/profile.dart';

class ProfileService {
  get(String email) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }

      if (snapshot.docs.length > 1) {
        print("Wey hay mas de 1 usuario con este correo. Limpia");
      }
      return Profile.fromSnapshot(snapshot.docs.first);
    } catch (e) {
      print(e);
    }
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
