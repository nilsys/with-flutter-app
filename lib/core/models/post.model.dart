import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'media.dart';

class Post {
  final String id;
  final String title;
  final String text;
  final DateTime timestamp;
  final List<String> media;

  Post({
    this.id,
    this.title,
    @required this.timestamp,
    this.text,
    this.media,
  });

  Post.fromMap(Map snapshot, String id)
      : id = id != null ? id : null,
        title = snapshot['title'],
        timestamp = (snapshot['timestamp'] as Timestamp).toDate(),
        text = snapshot['text'],
        media = snapshot['media'].cast<String>().toList();

  toJson() {
    return {
      "timestamp": timestamp,
      "title": title,
      "text": text,
      "media": media,
    };
  }
}
