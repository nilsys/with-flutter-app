import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';

import 'sub_views/hero_flexible_content.view.dart';

class TimelineHero extends StatefulWidget {
  final UserModel author;
  final Story story;
  final UserModel currentUser;
  final ScrollController scrollController;
  final Function goToSettings;

  TimelineHero({
    this.author,
    this.story,
    this.currentUser,
    @required this.scrollController,
    @required this.goToSettings,
  });

  @override
  _TimelineHeroState createState() => _TimelineHeroState();
}

class _TimelineHeroState extends State<TimelineHero>
    with SingleTickerProviderStateMixin {
  bool _isCollapsed = false;
  bool sharing = false;
  AnimationController animationController;
  Tween<double> tween;
  Animation animation;

  @override
  void initState() {
    super.initState();
    final storyProvider = Provider.of<StoryVM>(context, listen: false);
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    tween = Tween<double>(
        begin: storyProvider.prevExpandedHeight,
        end: storyProvider.expandedHeight);

    animation = tween.animate(new CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutCubic))
      ..addListener(() {
        setState(() {});
      });

    animationController.forward();
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(context) {
    final storyProvider = Provider.of<StoryVM>(context);
    final double _paddingTop = MediaQuery.of(context).padding.top;
    final double _appBarHeight = AppBar().preferredSize.height;
    bool isAuthor = widget.author?.id == widget.currentUser?.id;
    bool isFollower =
        widget.currentUser.stories.following.contains(widget.story.id);

    scrollToTop() {
      widget.scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }

    if (storyProvider.showDiscussion) {
      if (_isCollapsed) {
        scrollToTop();
      }
      tween.begin = storyProvider.expandedHeight;
      tween.end = storyProvider.expandedDiscussionHeight;
    } else {
      tween.begin = storyProvider.expandedDiscussionHeight;
      tween.end = storyProvider.expandedHeight;
    }

    Widget title = widget.author != null
        ? Transform.translate(
            offset: Offset(-15.0, 0.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              layoutBuilder:
                  (Widget currentChild, List<Widget> previousChildren) {
                return currentChild;
              },
              child: _isCollapsed
                  ? Transform.translate(
                      offset: Offset(0.0, -2.0),
                      child: Text(
                        widget.story.title,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: _isCollapsed
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        Avatar(
                          src: widget.author.profileImage,
                          radius: 18.0,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          widget.author.displayName,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
            ),
          )
        : SkeletonLoader(
            builder: Transform.translate(
              offset: Offset(0, -12.0),
              child: Container(
                height: 18,
                color: Colors.black,
              ),
            ),
            items: 1,
            period: Duration(seconds: 2),
            baseColor:
                TinyColor(Theme.of(context).primaryColor).lighten(4).color,
            hightlightColor:
                TinyColor(Theme.of(context).primaryColor).lighten(10).color,
          );

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          storyProvider.resetState();
          Navigator.pop(context);
        },
      ),
      title: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: animation.value + _appBarHeight + _paddingTop - 10.0,
      collapsedHeight: _paddingTop + _appBarHeight - 19.0,
      actions: [
        AnimatedOpacity(
          opacity: _isCollapsed || storyProvider.discussionFullView ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: InkWell(
            child: Container(
              width: 40.0,
              height: double.infinity,
              child: Center(
                child: Icon(
                  Icons.mode_comment,
                  size: 22.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            onTap: () {
              storyProvider.showDiscussion = !storyProvider.showDiscussion;
              storyProvider.discussionFullView =
                  !storyProvider.discussionFullView;
              animationController.reset();
              animationController.forward();
            },
          ),
        ),
        InkWell(
          child: Container(
            width: 40.0,
            height: double.infinity,
            child: Center(
              child: Icon(
                Icons.more_vert,
                size: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            // showModalBottomSheet(
            //     context: context,
            //     builder: (context) {
            //       return FractionallySizedBox(
            //         heightFactor: 0.4,
            //         child: Container(
            //           color: Theme.of(context).primaryColor,
            //           padding: EdgeInsets.all(22.0),
            //           child: Column(
            //             children: [
            //               listItem('SETTINGS', Icons.settings, () {}),
            //               SizedBox(
            //                 height: 15.0,
            //               ),
            //               listItem('SHARE', Icons.share,
            //                   sharing == false ? shareStoryLink : null),
            //             ],
            //           ),
            //         ),
            //       );
            //     });
            scrollToTop();
          },
        ),
      ],
      pinned: true,
      forceElevated: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final _height =
              max(constraints.biggest.height - _paddingTop - _appBarHeight, 0);
          if (_height < 10.0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_isCollapsed) {
                setState(() {
                  _isCollapsed = true;
                });
              }
            });
          } else if (_isCollapsed == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_isCollapsed) {
                setState(() {
                  _isCollapsed = false;
                });
              }
            });
          }
          final squeeze = min(
              1.0,
              max(_height / (storyProvider.expandedHeight + _paddingTop - 10.0),
                  0.0));
          return Opacity(
            opacity: storyProvider.showDiscussion ? 1 : 1 * squeeze,
            child: ClipRRect(
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minHeight: 0.0,
                maxHeight: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(top: _paddingTop + _appBarHeight),
                  padding: const EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 26.0),
                  child: HeroFlexibleContent(
                    story: widget.story,
                    isAuthor: isAuthor,
                    goToSettings: widget.goToSettings,
                    currentUser: widget.currentUser,
                    isFollower: isFollower,
                    animationController: animationController,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
