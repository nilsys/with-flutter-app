import 'dart:math';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'hero_flexible_content.view.dart';

class TimelineHero extends StatefulWidget {
  final ScrollController scrollController1;
  final Function goToSettings;

  TimelineHero({
    @required this.scrollController1,
    @required this.goToSettings,
  });

  @override
  _TimelineHeroState createState() => _TimelineHeroState();
}

class _TimelineHeroState extends State<TimelineHero>
    with TickerProviderStateMixin {
  final StoryVM storyProvider = locator<StoryVM>();
  final UserVM userProvider = locator<UserVM>();
  bool _isCollapsed = false;
  bool sharing = false;
  AnimationController animationController;
  Tween<double> tweenHeight;
  Animation<double> _heightAnimation;
  // AnimationController animationController2;
  // Tween<double> tweenDropArrow;
  // Animation<double> animateDropArrow;
  // double scaleDropMenuArrow = 0.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    tweenHeight = Tween<double>(
        begin: storyProvider.prevExpandedHeight,
        end: storyProvider.expandedHeight);

    _heightAnimation = tweenHeight.animate(new CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    ))
      ..addListener(() {
        setState(() {});
      });

    // animationController2 = AnimationController(
    //   duration: Duration(milliseconds: 2500),
    //   vsync: this,
    // );

    // tweenDropArrow = Tween<double>(begin: 0, end: 180 / 360);

    // animateDropArrow = tweenDropArrow.animate(CurvedAnimation(
    //   parent: animationController2,
    //   curve: Curves.easeInOutCubic,
    // ));

    animationController.forward();
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    // animationControllerForDropMenuArrow.dispose();
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @swidget
  Widget _notificationStastus() => Container(
        height: 13.0,
        width: 13.0,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      );

  @swidget
  Widget _discussionToggleBtn() => IconButton(
        icon: Icon(
          Icons.mode_comment,
          size: 22.0,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          storyProvider.showDiscussion = !storyProvider.showDiscussion;
          // storyProvider.discussionFullView =
          //     !storyProvider.discussionFullView;
          animationController.reset();
          animationController.forward();
        },
      );

  @swidget
  Widget _title() => Transform.translate(
        offset: Offset(-15.0, 0.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 0),
          layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
            return currentChild;
          },
          child: _isCollapsed || storyProvider.discussionFullView
              ? Transform.translate(
                  offset: Offset(0.0, -2.0),
                  child: Text(
                    storyProvider.story.title,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                )
              : Row(
                  mainAxisAlignment: _isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Avatar(
                      src: storyProvider.author.profileImage,
                      radius: 18.0,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      storyProvider.author.displayName,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
        ),
      );

  @override
  Widget build(context) {
    print(userProvider.user.logs[storyProvider.story.id]);
    final double _paddingTop = MediaQuery.of(context).padding.top;
    final double _appBarHeight = AppBar().preferredSize.height;
    bool isAuthor = storyProvider.author?.id == userProvider.user?.id;
    bool isFollower =
        userProvider.user.stories.following.contains(storyProvider.story.id);

    // tweenDropArrow.begin = _isCollapsed ? 180.0 / 360 : 0.0;
    // tweenDropArrow.end = _isCollapsed ? 0.0 : 180 / 360;

    scrollToTop() {
      widget.scrollController1.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }

    collapseHero() {
      widget.scrollController1.animateTo(
        storyProvider.expandedHeight + _paddingTop - 10.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      storyProvider.showDiscussion = false;
    }

    if (storyProvider.showDiscussion) {
      if (_isCollapsed) {
        scrollToTop();
      }
      tweenHeight.begin = storyProvider.expandedHeight;
      tweenHeight.end = storyProvider.expandedDiscussionHeight;
    } else {
      tweenHeight.begin = storyProvider.expandedDiscussionHeight;
      tweenHeight.end = storyProvider.expandedHeight;
    }

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          storyProvider.resetState();
          Navigator.pop(context);
        },
      ),
      title: _title(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight:
          _heightAnimation.value + _appBarHeight + _paddingTop - 10.0,
      collapsedHeight: _paddingTop + _appBarHeight - 22.0,
      actions: [
        Container(
          height: double.infinity,
          width: 48.0,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: _discussionToggleBtn(),
              ),
              Transform.translate(
                offset: Offset(-10.0, -9.0),
                child: Align(
                  alignment: Alignment.center,
                  child: _notificationStastus(),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            _isCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
          ),
          onPressed: _isCollapsed ? scrollToTop : collapseHero,
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
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: _paddingTop + _appBarHeight),
                  padding: const EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 26.0),
                  child: HeroFlexibleContent(
                    isAuthor: isAuthor,
                    goToSettings: widget.goToSettings,
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
