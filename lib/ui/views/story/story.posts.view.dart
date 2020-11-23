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

import 'story.cover.view.dart';
import 'story.post.view.dart';

class StoryPosts extends StatefulWidget {
  StoryPosts({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StoryPostsState createState() => _StoryPostsState();
}

class _StoryPostsState extends State<StoryPosts> {
  static const gutter = 16.0;
  static const verticalSpace = 30.0;
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
        // viewportBoundaryG2etter: () => Rect.fromLTRB(
        //     0,
        //     storyProvider.collpasedHeight,
        //     0,
        //     MediaQuery.of(context).padding.bottom),
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
    postsStream.cancel();
    super.dispose();
  }

  Future<void> scrollToIndex(i) async {
    await controller.scrollToIndex(
      i,
      preferPosition: AutoScrollPosition.end,
      duration: Duration(milliseconds: 700),
    );
    controller.highlight(
      i,
      highlightDuration: Duration(seconds: 1),
    );
  }

  @swidget
  Widget newPostsDivider(i) => Container(
        padding: EdgeInsets.fromLTRB(0, 22, 0, 18),
        child: Text(
          '$i Unread Posts',
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
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
      if (srcollToindex > 0) {
        scrollToIndex(srcollToindex);
      } else if (storyProvider.posts.length > 0) {
        // scrollToIndex(storyProvider.posts.length - 1); // TODO: implement for none followers
        scrollToIndex(0); // for followers
      }
    });
    List<Widget> posts =
        storyProvider.posts.reversed.toList().asMap().entries.map((entry) {
      int index = entry.key;
      Post post = entry.value;
      if (srcollToindex == 0 &&
          post.timestamp.isAfter(
              userProvider.user.logs[storyProvider.story.id].toDate())) {
        srcollToindex = index;
      }
      return AutoScrollTag(
          key: ValueKey(index),
          controller: controller,
          index: index,
          child: Column(
            children: [
              srcollToindex == index && index > 0
                  ? newPostsDivider(storyProvider.posts.length - srcollToindex)
                  : SizedBox(),
              StoryPost(
                post: post,
              ),
            ],
          ));
    }).toList();
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1),
      // appBar: AppBar(
      //   title: Text(storyProvider.story.title),
      //   elevation: 0.0,
      //   actions: [
      //     IconButton(
      //         icon: new Icon(Icons.expand_more),
      //         onPressed: () {
      //           storyCover.expandedView.tappedEvent();
      //         })
      //   ],
      // ),
      body: SafeArea(
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              padding: EdgeInsets.only(top: storyProvider.collpasedHeight),
              child: ListView(
                // addAutomaticKeepAlives: false,
                // addRepaintBoundaries: false,
                // addSemanticIndexes: false,
                reverse: true,
                scrollDirection: scrollDirection,
                controller: controller,
                children: [
                      AutoScrollTag(
                        key: ValueKey(storyProvider.posts.length),
                        controller: controller,
                        index: storyProvider.posts.length,
                        child: Padding(
                          padding: const EdgeInsets.all(gutter),
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  Text(
                                    'NEW POST',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] +
                    storyProvider.posts.reversed
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      Post post = entry.value;
                      if (srcollToindex == 0 &&
                          post.timestamp.isAfter(userProvider
                              .user.logs[storyProvider.story.id]
                              .toDate())) {
                        srcollToindex = index;
                      }
                      return AutoScrollTag(
                          key: ValueKey(index),
                          controller: controller,
                          index: index,
                          child: Column(
                            children: [
                              srcollToindex == index && index > 0
                                  ? newPostsDivider(storyProvider.posts.length -
                                      srcollToindex)
                                  : SizedBox(),
                              StoryPost(
                                post: post,
                              ),
                            ],
                          ));
                    }).toList(),
              ),
            ),
            StoryCover(),
          ],
        ),
      ),
    );
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(gutter),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Share',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Edit',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
