import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';

class DiscussionPost extends StatefulWidget {
  final Post post;

  DiscussionPost({
    @required this.post,
  });

  @override
  _DiscussionPostState createState() => _DiscussionPostState();
}

class _DiscussionPostState extends State<DiscussionPost>
    with TickerProviderStateMixin {
  final UserVM userProvider = locator<UserVM>();
  final StoryVM storyProvider = locator<StoryVM>();
  AnimationController animationController;
  bool _show = false;

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      setState(() {
        _show = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: storyProvider.showDiscussion && _show ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(top: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: userProvider.getUserById(widget.post.author),
                builder: (_, snapshot) {
                  if (snapshot.data != null) {
                    UserModel user = UserModel.fromMap(
                        snapshot.data.data(), widget.post.author);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Avatar(
                            src: user.profileImage,
                            radius: 20,
                          ),
                        ),
                        Text(user.displayName),
                      ],
                    );
                  }
                  return Spinner();
                }),
            Transform.translate(
              offset: Offset(0.0, -14.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.only(left: 55.0),
                // padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 12.0),
                child: Text(widget.post.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
