import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'post.model.dart';

class Discussion {
  final List<Post> posts; // list of user-id's

  Discussion({
    @required this.posts,
  });

  Discussion.fromMap(Map snapshot)
      : posts = snapshot.entries.map((e) => Post.fromMap(e));

  toJson() {
    return {
      "posts": posts.map((e) => e.toJson()),
    };
  }
}
