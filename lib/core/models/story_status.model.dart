import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StoryStatus {
  final String id;
  final DateTime lastViewedAt;
  final int newPosts;
  final int newComments;
  final int newReactions;

  StoryStatus({
    @required this.id,
    @required this.lastViewedAt,
    @required this.newPosts,
    @required this.newComments,
    @required this.newReactions,
  });

  StoryStatus.fromMap(Map snapshot)
      : id = snapshot['id'],
        lastViewedAt = (snapshot['last_viewed_at'] as Timestamp).toDate(),
        newPosts = snapshot['new_posts'],
        newComments = snapshot['new_comments'],
        newReactions = snapshot['new_reactions'];

  toJson() {
    return {
      "last_viewed_at": lastViewedAt,
    };
  }
}
