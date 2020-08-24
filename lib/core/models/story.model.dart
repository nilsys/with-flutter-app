import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Story {
  final String id;
  final DateTime createdAt;
  final String owner;
  final String title;
  final List<String> followers;
  final List<String> viewers;
  final int views;
  final String heroImage;

  Story({
    this.id,
    this.heroImage,
    @required this.createdAt,
    @required this.owner,
    @required this.title,
    @required this.followers,
    @required this.viewers,
    @required this.views,
  });

  Story.fromMap(Map snapshot, String id)
      : id = id ?? '',
        heroImage = snapshot['hero_image'] ?? null,
        createdAt = (snapshot['created_at'] as Timestamp).toDate(),
        owner = snapshot['owner'],
        title = snapshot['title'],
        followers = snapshot['followers'].cast<String>(),
        viewers = snapshot['viewers'].cast<String>(),
        views = snapshot['views'];

  toJson() {
    return {
      "created_at": createdAt,
      "owner": owner,
      "title": title,
      "followers": followers,
      "viewers": viewers,
      "views": views,
      "hero_image": heroImage,
    };
  }
}
