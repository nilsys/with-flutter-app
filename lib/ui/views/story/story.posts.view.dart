//Copyright (C) 2019 Potix Corporation. All Rights Reserved.
//History: Tue Apr 24 09:29 CST 2019
// Author: Jerry Chen

import 'dart:async';
import 'dart:math' as math;
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:strings/strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';

class StoryPosts extends StatefulWidget {
  StoryPosts({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StoryPostsState createState() => _StoryPostsState();
}

class _StoryPostsState extends State<StoryPosts> {
  static const maxCount = 100;
  static const gutter = 16.0;
  static const verticalSpace = 40.0;
  final random = math.Random();
  final scrollDirection = Axis.vertical;
  int srcollToindex = 0;

  // PROVIDERS
  final StoryVM storyProvider = locator<StoryVM>();
  final UserVM userProvider = locator<UserVM>();

  AutoScrollController controller;
  List<Map<String, dynamic>> randomList;
  StreamSubscription<QuerySnapshot> postsStream;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    postsStream = storyProvider.streamPosts().listen((QuerySnapshot data) {
      storyProvider.posts = data.docs.map((doc) {
        // if (doc.data()['timestamp'].toData().isAfter(userProvider.user.logs[storyProvider.story.id].toDate())) {

        // }
        return Post.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  void dispose() {
    // _timer.cancel();
    postsStream.cancel();
    super.dispose();
  }

  Future _scrollToIndex(i) async {
    // setState(() {
    //   counter++;

    //   if (counter >= maxCount) counter = 0;
    // });

    await controller.scrollToIndex(i, preferPosition: AutoScrollPosition.begin);
    controller.highlight(i);
  }

  @swidget
  Widget newPostsDivider(i) => Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
              margin: EdgeInsets.fromLTRB(
                0,
                verticalSpace / 2,
                0,
                verticalSpace,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(239, 239, 239, 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  '$i Unread Posts',
                  style: TextStyle(color: Theme.of(context).indicatorColor),
                ),
              ),
            ),
          ),
        ],
      );

  @swidget
  Widget postTopSection(timestamp) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(camelize(timeago.format(timestamp)),
              style: Theme.of(context).textTheme.subtitle2),
          IconButton(
            icon: Icon(Icons.more_horiz),
            color: Colors.black.withAlpha(100),
            splashRadius: 20.0,
            onPressed: showMenu,
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(srcollToindex);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(storyProvider.story.title),
      ),
      body: ListView.builder(
        scrollDirection: scrollDirection,
        controller: controller,
        itemCount: storyProvider.posts.length,
        itemBuilder: (_, index) {
          if (srcollToindex == 0 &&
              storyProvider.posts[index].timestamp.isAfter(
                  userProvider.user.logs[storyProvider.story.id].toDate())) {
            srcollToindex = index;
          }
          return AutoScrollTag(
            key: ValueKey(index),
            controller: controller,
            index: index,
            highlightColor: Colors.black.withOpacity(0.1),
            child: Container(
                padding: EdgeInsets.fromLTRB(gutter, 0, gutter, verticalSpace),
                child: Column(
                  children: [
                    srcollToindex == index
                        ? newPostsDivider(
                            storyProvider.posts.length - srcollToindex)
                        : SizedBox(),
                    postTopSection(storyProvider.posts[index].timestamp),
                    Text(
                      capitalize(storyProvider.posts[index].title),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text(storyProvider.posts[index].text),
                  ],
                )),
          );
        },
      ),
    );
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[Text('Bottom Drawer')],
            ),
          );
        });
  }
}
