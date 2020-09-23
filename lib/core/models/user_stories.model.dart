export 'package:with_app/core/models/story_status.model.dart';

class UserStories {
  final List<String> authoring;
  final List<String> following;
  final List<String> viewing;

  UserStories({
    this.authoring = const [],
    this.following = const [],
    this.viewing = const [],
  });

  UserStories.fromMap(Map snapshot)
      : authoring = snapshot['authoring'].cast<String>().toList(),
        following = snapshot['following'].cast<String>().toList(),
        viewing = snapshot['viewing'].cast<String>().toList();

  toJson() {
    return {
      "authoring": authoring,
      "following": following,
      "viewing": viewing,
    };
  }
}
