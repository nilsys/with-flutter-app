import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'discussion_input.view.dart';
import 'discussion_post.view.dart';

class StoryDiscussion extends StatefulWidget {
  final Function scrollToBottom;

  StoryDiscussion({
    @required this.scrollToBottom,
  });

  @override
  _StoryDiscussionState createState() => _StoryDiscussionState();
}

class _StoryDiscussionState extends State<StoryDiscussion> {
  final UserVM userProvider = locator<UserVM>();
  final StoryVM storyProvider = locator<StoryVM>();
  StreamSubscription<QuerySnapshot> discussionStream;
  // Timer _timer;

  @override
  void initState() {
    discussionStream =
        storyProvider.streamDiscussion().listen((QuerySnapshot data) {
      storyProvider.discussion =
          data.docs.map((doc) => Post.fromMap(doc.data())).toList();
    });
    super.initState();
  }

  @override
  void dispose() {
    // _timer.cancel();
    discussionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!storyProvider.keyboardIsOpen) {
    //   _timer = Timer(const Duration(milliseconds: 1000), () {
    //     FocusScope.of(context).unfocus();
    //   });
    // }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < storyProvider.discussion.length) {
            return DiscussionPost(post: storyProvider.discussion[index]);
          }
          return DiscussionIpnut(
            scrollToBottom: widget.scrollToBottom,
          );
        },
        childCount: storyProvider.discussion.length + 1,
      ),
    );
  }
}