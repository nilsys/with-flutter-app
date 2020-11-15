//Copyright (C) 2019 Potix Corporation. All Rights Reserved.
//History: Tue Apr 24 09:29 CST 2019
// Author: Jerry Chen

import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';

class StoryPosts extends StatefulWidget {
  StoryPosts({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StoryPostsState createState() => _StoryPostsState();
}

class _StoryPostsState extends State<StoryPosts> {
  static const maxCount = 100;
  final random = math.Random();
  final scrollDirection = Axis.vertical;
  final StoryVM storyProvider = locator<StoryVM>();

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
      storyProvider.posts =
          data.docs.map((doc) => Post.fromMap(doc.data())).toList();
    });
  }

  @override
  void dispose() {
    // _timer.cancel();
    postsStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Posts'),
      ),
      body: ListView.builder(
        scrollDirection: scrollDirection,
        controller: controller,
        itemCount: storyProvider.posts.length,
        itemBuilder: (_, index) => Container(
            child: Column(
          children: [
            Text(
              storyProvider.posts[index].title,
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(storyProvider.posts[index].text),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToIndex,
        tooltip: 'Increment',
        child: Text(counter.toString()),
      ),
    );
  }

  int counter = -1;
  Future _scrollToIndex() async {
    setState(() {
      counter++;

      if (counter >= maxCount) counter = 0;
    });

    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }

  Widget _getRow(int index, double height) {
    return _wrapScrollTag(
        index: index,
        child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.topCenter,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue, width: 4),
              borderRadius: BorderRadius.circular(12)),
          child: Text('index: $index, height: $height'),
        ));
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
}
