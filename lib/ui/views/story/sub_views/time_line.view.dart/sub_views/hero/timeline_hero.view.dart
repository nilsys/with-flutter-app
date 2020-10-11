import 'dart:async';
import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/with_icons.dart';

import 'sub_views/hero_flexible_content.view.dart';

class TimelineHero extends StatefulWidget {
  final UserModel author;
  final Story story;
  final UserModel currentUser;
  final ScrollController scrollController;
  final Function goToSettings;
  final Function onDiscussionToggle;

  TimelineHero({
    this.author,
    this.story,
    this.currentUser,
    @required this.scrollController,
    @required this.goToSettings,
    @required this.onDiscussionToggle,
  });

  @override
  _TimelineHeroState createState() => _TimelineHeroState();
}

class _TimelineHeroState extends State<TimelineHero> {
  bool _isCollapsed = false;
  bool sharing = false;
  double expandedHeight = 100.0;
  double descriptionHeight = 0.0;
  bool showDiscussion = false;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  SliverAppBar build(context) {
    final double _paddingTop = MediaQuery.of(context).padding.top;
    final double _appBarHeight = AppBar().preferredSize.height;
    bool isAuthor = widget.author?.id == widget.currentUser?.id;
    bool isFollower =
        widget.currentUser.stories.following.contains(widget.story.id);

    getExpandedHeight(height) {
      setState(() {
        expandedHeight = height + _appBarHeight + _paddingTop - 10.0;
      });
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
          Navigator.pop(context);
        },
      ),
      title: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: expandedHeight,
      collapsedHeight: _paddingTop + _appBarHeight - 19.0,
      actions: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Transform.translate(
              offset: Offset(0.0, 1.0),
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
            widget.scrollController.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
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
          final squeeze = max(_height / (expandedHeight - _appBarHeight), 0.0);
          return Opacity(
            opacity: 1 * squeeze,
            child: ClipRRect(
              // borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minHeight: 0.0,
                maxHeight: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(top: _paddingTop + _appBarHeight),
                  padding: const EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 26.0),
                  child: HeroFlexibleContent(
                    // height: expandedHeight - _appBarHeight - _paddingTop,
                    story: widget.story,
                    isAuthor: isAuthor,
                    goToSettings: widget.goToSettings,
                    currentUser: widget.currentUser,
                    onDiscussionToggle: ((showDiscussion) {
                      widget.onDiscussionToggle(showDiscussion);
                      // setState(() {
                      //   expandedHeight += (showDiscussion ? 300 : -300);
                      // });
                    }),
                    isFollower: isFollower,
                    getExpandedHeight: getExpandedHeight,
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
