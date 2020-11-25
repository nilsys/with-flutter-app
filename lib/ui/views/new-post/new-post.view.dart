import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:with_app/core/view_models/camera.vm.dart';
import 'package:with_app/core/view_models/layout.vm.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'select-story.view.dart';
import 'edit-post.view.dart';

final NavigationService navService = NavigationService();

class NewPostView extends StatefulWidget {
  static const String route = 'new-post';
  final String postId;
  final int step;
  final int postIndex;

  NewPostView({
    this.step = 0,
    this.postIndex,
    this.postId,
  });

  @override
  _NewPostViewState createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final LayoutVM layoutProvider = locator<LayoutVM>();

  final storyProvider = locator<StoryVM>();

  final CameraVM cameraProvider = locator<CameraVM>();

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
    cameraProvider.clearFiles();
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
          EditPostView(
            story: storyProvider.currentStory,
            postId: widget.postId,
            postIndex: widget.postIndex,
          ),
          // StorySettings(
          //   goToTimeline: goToTimeline,
          // ),
        ],
      ),
    );
  }
}
