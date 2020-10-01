import 'package:floating_pullup_card/floating_layout.dart';
import 'package:floating_pullup_card/floating_pullup_card.dart';
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
      body: FloatingPullUpCardLayout(
        cardElevation: 25,
        autoPadding: false,
        state: hideDiscussionTab
            ? FloatingPullUpState.hidden
            : FloatingPullUpState.collapsed,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        dragHandleBuilder: (context, constraints, beingDragged) {
          return Container(
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Center(
              child: Text('Discussion... TBD'),
            ),
          );
        },
        body: Text('Hello', style: Theme.of(context).textTheme.bodyText1),
        cardBuilder: (
          context,
          constraints,
          dragHandler,
          body,
          beingDragged,
        ) {
          return Transform.translate(
            offset: Offset(0.0, 8.0),
            child: Container(
              child: Column(
                children: [
                  dragHandler,
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: body,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
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
      ),
    );
  }
}
