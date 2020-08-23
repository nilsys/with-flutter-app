import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;

  User({
    this.id,
    @required this.firstName,
    @required this.lastName,
  });

  User.fromMap(Map snapshot, String id)
      : id = id ?? '',
        firstName = snapshot['first_name'],
        lastName = snapshot['last_name'];

  toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
    };
  }
}
