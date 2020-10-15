import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'post.view.dart';
import 'hero/hero.view.dart';

class Timeline extends StatefulWidget {
  final Story story;
  final UserModel currentUser;
  final UserModel author;
  final Function goToSettings;

  Timeline({
    Key key,
    this.story,
    this.currentUser,
    this.author,
    @required this.goToSettings,
  }) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  ScrollController scrollController = ScrollController();
  bool hideDiscussionTab = true;

  var maxHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryVM>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(this.context).unfocus();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == 0.0) {
                if (!hideDiscussionTab) {
                  setState(() {
                    hideDiscussionTab = true;
                  });
                }
              } else if (hideDiscussionTab) {
                print(scrollInfo.metrics.pixels);
                setState(() {
                  hideDiscussionTab = false;
                });
              }
              return false;
            },
            child: CustomScrollView(
              controller: scrollController,
              physics: storyProvider.showDiscussion
                  ? NeverScrollableScrollPhysics()
                  : null,
              slivers: <Widget>[
                TimelineHero(
                  author: widget.author,
                  story: widget.story,
                  currentUser: widget.currentUser,
                  scrollController: scrollController,
                  goToSettings: widget.goToSettings,
                ),
                // Skeleton(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 22.0,
                            ),
                            PostCard(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
