import 'package:flutter/foundation.dart';
import 'package:with_app/core/models/user_stories.model.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String profileImage;
  final UserStories stories;
  final List<String> leads;
  final DateTime dayOfBirth;

  UserModel({
    this.id,
    @required this.displayName,
    @required this.email,
    @required this.stories,
    @required this.leads,
    @required this.dayOfBirth,
    this.profileImage,
  });

  UserModel.fromMap(Map snapshot, String id)
      : id = id ?? '',
        displayName = snapshot['display_name'],
        email = snapshot['email'],
        stories = snapshot['storeis'],
        leads = snapshot['leads'],
        dayOfBirth = snapshot['day_of_birth'].toDate(),
        profileImage = snapshot['profile_image'];

  toJson() {
    return {
      "display_name": displayName,
      "email": email,
      "profile_image": profileImage,
      "stories": stories,
      "leads": leads,
      "day_of_birth": dayOfBirth,
    };
  }
}
