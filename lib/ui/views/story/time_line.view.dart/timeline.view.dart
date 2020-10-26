import 'package:flutter/material.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'post.view.dart';
import 'hero/hero.view.dart';

class Timeline extends StatefulWidget {
  final Function goToSettings;

  Timeline({
    Key key,
    @required this.goToSettings,
  }) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final StoryVM storyProvider = locator<StoryVM>();
  ScrollController scrollController1 = new ScrollController();
  bool hideDiscussionTab = true;

  var maxHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
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
                controller: scrollController1,
                physics: storyProvider.showDiscussion
                    ? NeverScrollableScrollPhysics()
                    : null,
                slivers: <Widget>[
                  TimelineHero(
                    scrollController1: scrollController1,
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
          // Camera(),
        ],
      ),
    );
  }
}
