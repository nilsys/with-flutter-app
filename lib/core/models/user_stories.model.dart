import 'package:flutter/foundation.dart';
import 'package:with_app/core/models/story_status.model.dart';

class UserStories {
  final List<StoryStatus> owner;
  final List<StoryStatus> following;
  final List<StoryStatus> viewing;

  UserStories({
    @required this.owner,
    @required this.following,
    @required this.viewing,
  });

  UserStories.fromMap(Map snapshot)
      : owner = snapshot['owner'],
        following = snapshot['following'],
        viewing = snapshot['viewing'];

  toJson() {
    return {
      "owner": owner,
      "following": following,
      "viewing": viewing,
    };
  }
}
