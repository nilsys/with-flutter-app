import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:with_app/core/models/reaction.model.dart';

class Post {
  final String id;
  final String title;
  final String text;
  final DateTime timestamp;
  final List<String> media;

  Post({
    this.id,
    @required this.title,
    @required this.timestamp,
    this.text,
    this.media,
  });

  Post.fromMap(Map snapshot)
      : id = snapshot['id'] ?? '',
        title = snapshot['title'],
        timestamp = (snapshot['timestamp'] as Timestamp).toDate(),
        text = snapshot['text'],
        media = snapshot['media'];

  toJson() {
    return {
      "timestamp": timestamp,
      "title": title,
      "text": text,
      "media": media,
    };
  }
}
