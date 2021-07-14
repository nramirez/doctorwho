import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String name;
  final String lastname;
  final String phone;
  final String gender;
  final DateTime birthdate;
  final String email;
  final String role;
  DocumentReference reference;

  Profile(
      {this.name,
      this.lastname,
      this.phone,
      this.gender,
      this.birthdate,
      this.email,
      this.role});

  Profile.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data.call(), reference: snapshot.reference);

  Profile.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        email = map['email'],
        birthdate = map['birthdate'].toDate().toUtc(),
        lastname = map['lastname'],
        phone = map['phone'],
        gender = map['gender'],
        role = map['role'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastname,
      'phone': phone,
      'gender': gender,
      'birthdate': birthdate,
      'email': email,
      'role': role.toUpperCase()
    };
  }

  String fullname() => name + " " + lastname;

  String formattedBirthDate() =>
      "${birthdate.day}/${birthdate.month}/${birthdate.year}";

  bool isAdmin() => role.toUpperCase() == "ADMIN";
}
