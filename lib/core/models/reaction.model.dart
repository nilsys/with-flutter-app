import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Reaction {
  final String author;
  final DateTime createdAt;
  final String type;

  Reaction({
    @required this.author,
    @required this.createdAt,
    @required this.type,
  });

  Reaction.fromMap(Map snapshot)
      : author = snapshot['author'],
        createdAt = (snapshot['created_at'] as Timestamp).toDate(),
        type = snapshot['type'];

  toJson() {
    return {
      "author": author,
      "type": type,
      "created_at": createdAt,
    };
  }
}
