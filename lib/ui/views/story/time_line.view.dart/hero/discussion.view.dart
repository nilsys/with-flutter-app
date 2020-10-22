import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
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
  // Timer _timer;

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!storyProvider.keyboardIsOpen) {
    //   _timer = Timer(const Duration(milliseconds: 1000), () {
    //     FocusScope.of(context).unfocus();
    //   });
    // }

    return StreamBuilder<QuerySnapshot>(
        stream: storyProvider.streamDiscussion(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data.docs
                .map((doc) => Post.fromMap(doc.data()))
                .toList();
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < snapshot.data?.size) {
                    return DiscussionPost(post: posts[index]);
                  }
                  return DiscussionIpnut(
                    scrollToBottom: widget.scrollToBottom,
                  );
                },
                childCount: snapshot.hasData ? snapshot.data.size + 1 : 1,
              ),
            );
          }
          return SliverList(
            delegate: SliverChildListDelegate([
              Spinner(),
            ]),
          );
        });
  }
}
