import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Story {
  final String id;
  final DateTime createdAt;
  final DateTime closedAt;
  final String owner;
  final String title;
  final List<String> followers;
  final List<String> viewers;
  final int views;
  final int posts;
  final String heroImage;
  final String description;
  final String cover;
  final String privateTo;
  final bool private;

  Story({
    this.id,
    this.heroImage,
    this.description,
    @required this.createdAt,
    @required this.closedAt,
    @required this.owner,
    @required this.title,
    @required this.followers,
    @required this.viewers,
    @required this.views,
    @required this.private,
    @required this.posts,
    this.privateTo,
    this.cover,
  });

  Story.fromMap(Map snapshot, String id)
      : id = id ?? '',
        heroImage = snapshot['hero_image'] ?? null,
        createdAt = (snapshot['created_at'] as Timestamp).toDate(),
        closedAt = snapshot['closed_at'] != null
            ? (snapshot['closed_at'] as Timestamp).toDate()
            : null,
        owner = snapshot['owner'],
        title = snapshot['title'],
        followers = snapshot['followers'].cast<String>().toList(),
        viewers = snapshot['viewers'].cast<String>().toList(),
        views = snapshot['views'],
        private = snapshot['private'],
        posts = snapshot['posts'],
        cover = snapshot['cover'],
        privateTo = snapshot['privateTo'],
        description = snapshot['description'];

  toJson() {
    return {
      "created_at": createdAt,
      "closed_at": closedAt,
      "owner": owner,
      "title": title,
      "followers": followers,
      "viewers": viewers,
      "views": views,
      "hero_image": heroImage,
      "description": description,
      "private": private,
      "cover": cover,
      "privateTo": privateTo,
      "posts": posts,
    };
  }
}
