import 'package:flutter/foundation.dart';
import 'package:with_app/core/models/user_stories.model.dart';
export 'package:with_app/core/models/user_stories.model.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String profileImage;
  final UserStories stories;
  final Map<String, dynamic> logs;
  final List<String> leads;
  final DateTime dayOfBirth;

  UserModel({
    this.id,
    @required this.displayName,
    @required this.email,
    this.stories,
    this.leads,
    this.dayOfBirth,
    this.profileImage,
    this.logs,
  });

  UserModel.fromMap(Map<String, dynamic> data, String id)
      : id = id ?? '',
        displayName = data['display_name'],
        email = data['email'],
        stories = UserStories.fromMap(data['stories']),
        logs = data['logs'],
        leads = data['leads'] ?? List(),
        dayOfBirth =
            data['day_of_birth'] != null ? data['day_of_birth'].toDate() : null,
        profileImage = data['profile_image'];

  toJson() {
    Map<String, dynamic> obj = {};
    if (displayName != null) {
      obj["display_name"] = displayName;
    }
    if (email != null) {
      obj["email"] = email;
    }
    if (profileImage != null) {
      obj["profile_image"] = profileImage;
    }
    if (stories != null) {
      obj["stories"] = stories;
    }
    if (leads != null) {
      obj["leads"] = leads;
    }
    if (dayOfBirth != null) {
      obj["day_of_birth"] = dayOfBirth;
    }
    if (logs != null) {
      obj["logs"] = logs;
    }
    return obj;
  }
}
