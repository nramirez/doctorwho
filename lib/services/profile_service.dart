import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorme/models/profile.dart';

class ProfileService {
  bool isNullOrEmpty(String text) => text == null || text.isEmpty;

  get({String email, String phone}) async {
    if (isNullOrEmpty(email) && isNullOrEmpty(phone)) {
      return null;
    }

    try {
      var snapshot;
      if (!isNullOrEmpty(email)) {
        snapshot = await FirebaseFirestore.instance
            .collection('profiles')
            .where('email', isEqualTo: email)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('profiles')
            .where('phone', isEqualTo: phone)
            .get();
      }

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
      var existente = await get(email: perfil.email);
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

  update(Profile perfil) async {
    try {
      var existente = await get(email: perfil.email);
      if (existente == null) {
        print("El usuario no existe");
        return null;
      }

      await FirebaseFirestore.instance
          .doc(perfil.reference.path)
          .update(perfil.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<List<Profile>> getAll() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('profiles').get();

    List<Profile> patients = [];

    snapshot.docs.forEach((doc) {
      patients.add(Profile.fromSnapshot(doc));
    });

    return patients;
  }
}
