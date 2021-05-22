import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String name;
  final String lastname;
  final String phone;
  final String gender;
  final DateTime birthdate;
  final String email;
  DocumentReference reference;

  Profile(
      {this.name,
      this.lastname,
      this.phone,
      this.gender,
      this.birthdate,
      this.email});

  Profile.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data.call(), reference: snapshot.reference);

  Profile.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        email = map['email'],
        birthdate = map['birthdate'].toDate(),
        lastname = map['lastname'],
        phone = map['phone'],
        gender = map['gender'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastname,
      'phone': phone,
      'gender': gender,
      'birthdate': birthdate,
      'email': email
    };
  }
}
