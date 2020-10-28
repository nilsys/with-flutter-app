import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'story_settings.view.dart/story_settings.view.dart';
import 'time_line.view.dart/timeline.view.dart';

class StoryView extends StatefulWidget {
  static const String route = 'story';
  final String id;

  StoryView({
    @required this.id,
  });

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final StoryVM storyProvider = locator<StoryVM>();
  final UserVM userProvider = locator<UserVM>();
  StreamSubscription<DocumentSnapshot> storyAutorStream;
  StreamSubscription<DocumentSnapshot> storyStream;

  final pageController = PageController(
    initialPage: 0,
  );
  bool sharing = false;

  void goToSettings() {
    pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void goToTimeline() {
    pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void initState() {
    // currentUserStream =
    //     userProvider.fetchCurrentUserAsStream().listen((DocumentSnapshot doc) {
    //   userProvider.user = UserModel.fromMap(doc.data(), doc.id);
    // });
    storyStream = storyProvider
        .fetchStoryAsStream(widget.id)
        .listen((DocumentSnapshot doc) {
      storyProvider.story = Story.fromMap(doc.data(), doc.id);
      storyAutorStream = userProvider
          .fetchUserAsStream(storyProvider.story.owner)
          .listen((DocumentSnapshot doc) {
        storyProvider.author = UserModel.fromMap(doc.data(), doc.id);
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<StoryVM>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    pageController.dispose();
    storyStream.cancel();
    storyAutorStream.cancel();
    userProvider.logEntry(storyProvider.story.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: storyProvider.author != null
          ? PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                Timeline(
                  goToSettings: goToSettings,
                ),
                StorySettings(
                  goToTimeline: goToTimeline,
                ),
              ],
            )
          : Spinner(),
      // bottomNavigationBar: StoryFooter(
      //   onChange: (pageIndex) {
      //     pageController.animateToPage(
      //       pageIndex,
      //       duration: Duration(milliseconds: 400),
      //       curve: Curves.easeInOutCubic,
      //     );
      //   },
      // ),
    );
  }
}
