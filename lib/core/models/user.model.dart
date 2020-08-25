import 'package:flutter/foundation.dart';
import 'package:with_app/core/models/user_stories.model.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String email;
  final String profileImage;
  final UserStories stories;
  final List<String> leads;

  User({
    this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.displayName,
    @required this.email,
    @required this.stories,
    @required this.leads,
    this.profileImage,
  });

  User.fromMap(Map snapshot, String id)
      : id = id ?? '',
        firstName = snapshot['first_name'],
        lastName = snapshot['last_name'],
        displayName = snapshot['display_name'],
        email = snapshot['email'],
        stories = snapshot['storeis'],
        leads = snapshot['leads'],
        profileImage = snapshot['profile_image'];

  toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "display_name": displayName,
      "email": email,
      "profile_image": profileImage,
      "stories": stories,
      "leads": leads,
    };
  }
}
