import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:with_app/core/models/media_item.model.dart';
import 'package:with_app/core/models/reaction.model.dart';

class Post {
  final String id;
  final String author;
  final DateTime createdAt;
  final String text;
  final List<MediaItem> media;
  final List<Reaction> reactions;

  Post({
    this.id,
    @required this.author,
    @required this.createdAt,
    @required this.text,
    @required this.media,
    @required this.reactions,
  });

  Post.fromMap(Map snapshot)
      : id = snapshot['id'] ?? '',
        author = snapshot['author'],
        createdAt = (snapshot['created_at'] as Timestamp).toDate(),
        text = snapshot['text'],
        media = snapshot['media'],
        reactions = snapshot['reactions'];

  toJson() {
    return {
      "author": author,
      "created_at": createdAt,
      "text": text,
      "media": media,
      "reactions": reactions,
    };
  }
}
