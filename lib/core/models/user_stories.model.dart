import 'package:with_app/core/models/story_status.model.dart';
export 'package:with_app/core/models/story_status.model.dart';

class UserStories {
  final List<StoryStatus> owner;
  final List<StoryStatus> following;
  final List<StoryStatus> viewing;

  UserStories({
    this.owner = const [],
    this.following = const [],
    this.viewing = const [],
  });

  UserStories.fromMap(Map snapshot)
      : owner = snapshot['owner'] ?? List(),
        following = snapshot['following'] ?? List(),
        viewing = snapshot['viewing'] ?? List();

  toJson() {
    return {
      "owner": owner.map((e) => e.toJson()).toList(),
      "following": following.map((e) => e.toJson()).toList(),
      "viewing": viewing.map((e) => e.toJson()).toList(),
    };
  }
}
