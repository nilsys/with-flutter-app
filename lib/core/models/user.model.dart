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
    this.stories,
    this.leads,
    this.dayOfBirth,
    @required this.profileImage,
  });

  UserModel.fromMap(Map<String, dynamic> data, String id)
      : id = id ?? '',
        displayName = data['display_name'],
        email = data['email'],
        stories = data['storeis'] ?? UserStories(),
        leads = data['leads'] ?? List(),
        dayOfBirth =
            data['day_of_birth'] != null ? data['day_of_birth'].toDate() : null,
        profileImage = data['profile_image'];

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
