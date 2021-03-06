import 'dart:async';
import 'dart:math';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:share/share.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/with_icons.dart';

class HeroFlexibleContent extends StatefulWidget {
  // final double height;
  final Story story;
  final bool isAuthor;
  final UserModel currentUser;
  final Function goToSettings;
  final bool isFollower;
  final AnimationController animationController;

  HeroFlexibleContent({
    // @required this.height,
    @required this.isAuthor,
    @required this.goToSettings,
    this.story,
    this.currentUser,
    @required this.isFollower,
    @required this.animationController,
  });

  @override
  _HeroFlexibleContentState createState() => _HeroFlexibleContentState();
}

class _HeroFlexibleContentState extends State<HeroFlexibleContent> {
  GlobalKey _descriptionKey = GlobalKey();
  bool sharing = false;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    widget.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryVM>(context);
    final userProvider = Provider.of<UserVM>(context);
    final double staticHeight = widget.isAuthor ? 224.0 : 170.0;
    final double _paddingTop = MediaQuery.of(context).padding.top;
    final double _appBarHeight = AppBar().preferredSize.height;
    final double _deviceHeight = MediaQuery.of(context).size.height;

    final Function shareStoryLink = () async {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://withapp.page.link',
        link: Uri.parse('https://withapp.io/go-to-story?id=${widget.story.id}'),
        androidParameters: AndroidParameters(
          packageName: 'io.withapp.android',
          minimumVersion: 125,
        ),
        iosParameters: IosParameters(
          bundleId: 'io.withapp.ios',
          minimumVersion: '1.0.1',
          appStoreId: '123456789',
        ),
        // googleAnalyticsParameters: GoogleAnalyticsParameters(
        //   campaign: 'example-promo',
        //   medium: 'social',
        //   source: 'orkut',
        // ),
        // itunesConnectAnalyticsParameters:
        //     ItunesConnectAnalyticsParameters(
        //   providerToken: '123456',
        //   campaignToken: 'example-promo',
        // ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: widget.story.title,
          description: 'This story was created on with-app',
        ),
      );
      final ShortDynamicLink shortDynamicLink =
          await parameters.buildShortLink();
      final Uri shortUrl = shortDynamicLink.shortUrl;
      print(shortUrl);
      // final Uri dynamicUrl = await parameters.buildUrl();
      if (sharing == false) {
        Share.share('Check out my story\n\n$shortUrl',
            subject: widget.story.title);
      }
      setState(() {
        sharing = true;
      });
      Timer(Duration(milliseconds: 1000), () {
        setState(() {
          sharing = false;
        });
      });
    };

    final Function followStory = () {
      storyProvider.addFollower(widget.story);
      userProvider.followStory(widget.story.id, widget.currentUser);
    };

    final Function unFollowStory = () {
      storyProvider.removeFollower(widget.story);
      userProvider.unFollowStory(widget.story.id, widget.currentUser);
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storyProvider.expandedDiscussionHeight == 0) {
        storyProvider.expandedDiscussionHeight =
            _deviceHeight - _paddingTop - _appBarHeight - 50.0;
      }
      final keyContext = _descriptionKey.currentContext;
      if (keyContext != null) {
        final _descriptionBox = keyContext.findRenderObject() as RenderBox;
        final double newHeight = _descriptionBox.size.height;
        if (newHeight != storyProvider.descriptionHeight) {
          storyProvider.expandedHeight =
              staticHeight + _descriptionBox.size.height;
          storyProvider.descriptionHeight = _descriptionBox.size.height;
          widget.animationController.reset();
          widget.animationController.forward();
        }
      }
    });

    @swidget
    Widget counter(String name, num val) {
      return Padding(
        padding: const EdgeInsets.only(right: 21.0),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              toCurrencyString(
                '$val',
                mantissaLength: 0,
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 7.0,
            ),
            Opacity(
              opacity: 0.5,
              child: Text(name),
            ),
          ],
        ),
      );
    }

    Widget stats = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0, 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          counter('posts', widget.story.posts),
          counter('followers', widget.story.followers.length),
          counter('views', widget.story.views),
        ],
      ),
    );

    @swidget
    Widget followBtn() => widget.isFollower
        ? OutlineButton(
            onPressed: unFollowStory,
            highlightedBorderColor: Colors.white,
            borderSide: BorderSide(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 1,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 20.0,
                ),
                SizedBox(
                  width: 6.0,
                ),
                Text(
                  'UNFOLLOW',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : RaisedButton(
            onPressed: followStory,
            color: Colors.white,
            textColor: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Icon(
                  Icons.bookmark,
                  size: 20.0,
                ),
                SizedBox(
                  width: 6.0,
                ),
                Text(
                  'FOLLOW',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );

    @swidget
    Widget settingsBtn() => Container(
          width: 40.0,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: widget.goToSettings,
            child: Icon(With.settings),
          ),
        );

    @swidget
    Widget shareBtn() => Container(
          width: 40.0,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: shareStoryLink,
            child: Icon(Icons.share),
          ),
        );

    // @swidget
    // Widget discussionBtn() {
    //   return Transform.translate(
    //     offset: Offset(0.0, 0.0),
    //     child: Container(
    //       width: 40.0,
    //       child: FlatButton(
    //         padding: EdgeInsets.all(0.0),
    //         onPressed: () {
    //           storyProvider.showDiscussion = !storyProvider.showDiscussion;
    //           widget.animationController.reset();
    //           widget.animationController.forward();
    //         },
    //         child: Icon(Icons.mode_comment),
    //         textColor: Theme.of(context).accentColor,
    //       ),
    //     ),
    //   );
    // }

    scrollToTop() {
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 150),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        if (scrollController.offset != 0.0 && !storyProvider.showDiscussion) {
          // scrollController.jumpTo(
          //   0.0,
          // );
          scrollToTop();
        }
        // else if (storyProvider.discussionFullView &&
        //     scrollController.offset == 0.0) {
        //   scrollController.jumpTo(
        //     storyProvider.expandedHeight,
        //   );
        // }
      }
    });

    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      height: storyProvider.expandedDiscussionHeight,
      child: CustomScrollView(
        controller: scrollController,
        physics: storyProvider.showDiscussion
            ? null
            : NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            titleSpacing: 0.0,
            expandedHeight: storyProvider.expandedHeight - 10.0,
            collapsedHeight: 1.0,
            toolbarHeight: 0.0,
            elevation: 0.0,
            // pinned: true,
            floating: true,
            // leading: null,
            forceElevated: false,
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final _height = max(constraints.biggest.height, 0);
                final opacity = min(
                    max((_height - 25.0) / storyProvider.expandedHeight, 0.0),
                    1.0);
                if (_height < 35.0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!storyProvider.discussionFullView) {
                      storyProvider.discussionFullView = true;
                    }
                  });
                } else if (storyProvider.discussionFullView == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (storyProvider.discussionFullView) {
                      storyProvider.discussionFullView = false;
                    }
                  });
                }
                return Opacity(
                  opacity: 1 * opacity,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 750),
                    curve: Curves.easeInOutCubic,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.white.withAlpha(
                              storyProvider.showDiscussion ? 255 : 0),
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      child: OverflowBox(
                        alignment: Alignment.topLeft,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                widget.story.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              widget.story.description,
                              key: _descriptionKey,
                            ),
                            stats,
                            Row(
                              children: [
                                widget.isAuthor ? SizedBox() : followBtn(),
                                SizedBox(
                                  width: 8.0,
                                ),
                                settingsBtn(),
                                shareBtn(),
                                Spacer(),
                                // discussionBtn(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index < 14
                    ? AnimatedOpacity(
                        opacity: storyProvider.showDiscussion ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 22.0,
                              ),
                              Text('Comment ${index + 1}'),
                            ],
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: storyProvider.showDiscussion ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 22.0,
                                  ),
                                  Text('Comment ${index + 1}'),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.red,
                              height: 40.0,
                              child: Center(
                                child: Text('Input box'),
                              ),
                            ),
                          ],
                        ),
                      );
              },
              childCount: 15,
            ),
          ),
        ],
      ),
    );
  }
}
