import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Discussion {
  final String id;
  final DateTime createdAt;
  final List<String> members; // list of user-id's

  Discussion({
    this.id,
    @required this.createdAt,
    @required this.members,
  });

  Discussion.fromMap(Map snapshot)
      : id = snapshot['id'] ?? '',
        createdAt = (snapshot['created_at'] as Timestamp).toDate(),
        members = snapshot['members'];

  toJson() {
    return {
      "created_at": createdAt,
      "members": members,
    };
  }
}
