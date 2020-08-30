import 'package:flutter/foundation.dart';
import 'package:with_app/core/models/user_stories.model.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileImage;
  final UserStories stories;
  final List<String> leads;

  UserModel({
    this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.stories,
    @required this.leads,
    this.profileImage,
  });

  UserModel.fromMap(Map snapshot, String id)
      : id = id ?? '',
        firstName = snapshot['full_name'].split(' ')[0],
        lastName = snapshot['full_name'].split(' ')[1],
        email = snapshot['email'],
        stories = snapshot['storeis'],
        leads = snapshot['leads'],
        profileImage = snapshot['profile_image'];

  toJson() {
    return {
      "full_name": '$firstName $lastName',
      "email": email,
      "profile_image": profileImage,
      "stories": stories,
      "leads": leads,
    };
  }
}
