import 'package:flutter/foundation.dart';

class Story {
  final String id;
  final String owner;
  final String title;

  Story({
    this.id,
    @required this.owner,
    @required this.title,
  });

  Story.fromMap(Map snapshot, String id)
      : id = id ?? '',
        owner = snapshot['owner'],
        title = snapshot['title'];

  toJson() {
    return {
      "owner": owner,
      "title": title,
    };
  }
}
