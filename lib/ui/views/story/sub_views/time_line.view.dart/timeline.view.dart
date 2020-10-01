import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'sub_views/post.view.dart';
import 'sub_views/timeline_hero.view.dart';

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
  bool disableScroll = false;
  void onDiscussionToggle(bool disable) {
    setState(() {
      disableScroll = disable;
    });
  }

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
              physics: disableScroll ? NeverScrollableScrollPhysics() : null,
              slivers: <Widget>[
                TimelineHero(
                  author: widget.author,
                  story: widget.story,
                  currentUser: widget.currentUser,
                  scrollController: scrollController,
                  goToSettings: widget.goToSettings,
                  onDiscussionToggle: onDiscussionToggle,
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
