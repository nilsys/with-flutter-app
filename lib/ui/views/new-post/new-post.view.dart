import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:with_app/core/view_models/layout.vm.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'select-story.view.dart';
import 'edit-post.view copy.dart';

final NavigationService navService = NavigationService();

class NewPostView extends StatefulWidget {
  static const String route = 'new-post';
  final String storyId;
  final int step;

  NewPostView({
    this.storyId,
    this.step = 0,
  });

  @override
  _NewPostViewState createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final LayoutVM layoutProvider = locator<LayoutVM>();
  final storyProvider = locator<StoryVM>();
  StreamSubscription<QuerySnapshot> storiesStream;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: widget.step,
    );
    storiesStream =
        storyProvider.fetchStoriesAsStream().listen((QuerySnapshot data) {
      storyProvider.storyList = data.docs.map((doc) {
        return Story.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    storiesStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          SelectStoryView(),
          EditPostView(story: storyProvider.storyList[0]),
          // StorySettings(
          //   goToTimeline: goToTimeline,
          // ),
        ],
      ),
    );
  }
}
