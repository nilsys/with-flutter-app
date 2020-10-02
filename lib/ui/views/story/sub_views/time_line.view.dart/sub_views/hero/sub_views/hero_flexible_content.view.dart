import 'dart:async';

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
  final double height;
  final bool lock;
  final Story story;
  final bool isAuthor;
  final UserModel currentUser;
  final Function goToSettings;
  final Function onDiscussionToggle;
  final Function getExpandedHeight;
  final bool isFollower;

  HeroFlexibleContent({
    @required this.height,
    @required this.isAuthor,
    @required this.goToSettings,
    this.lock = true,
    this.story,
    this.currentUser,
    @required this.onDiscussionToggle,
    @required this.isFollower,
    @required this.getExpandedHeight,
  });

  @override
  _HeroFlexibleContentState createState() => _HeroFlexibleContentState();
}

class _HeroFlexibleContentState extends State<HeroFlexibleContent> {
  GlobalKey _descriptionKey = GlobalKey();
  double descriptionHeight = 0.0;
  double expandedHeight = 100.0;
  bool showDiscussion = false;
  bool sharing = false;

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryVM>(context);
    final userProvider = Provider.of<UserVM>(context);
    final double staticHeight = widget.isAuthor ? 224.0 : 254.0;

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
      final keyContext = _descriptionKey.currentContext;
      if (keyContext != null) {
        final _descriptionBox = keyContext.findRenderObject() as RenderBox;
        final double newHeight = _descriptionBox.size.height;
        if (newHeight != descriptionHeight) {
          setState(() {
            expandedHeight = staticHeight + _descriptionBox.size.height;
            descriptionHeight = _descriptionBox.size.height;
            // collapsedHeight = 0.0;
          });
          widget.getExpandedHeight(expandedHeight);
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
              color: Colors.white, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 1, //width of the border
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

    @swidget
    Widget discussionBtn() {
      return Transform.translate(
        offset: Offset(10.0, 0.0),
        child: Container(
          width: 40.0,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              setState(() {
                showDiscussion = !showDiscussion;
                expandedHeight += showDiscussion ? 300 : -300;
              });
              widget.onDiscussionToggle(showDiscussion);
            },
            child: Icon(Icons.mode_comment),
            textColor: Theme.of(context).accentColor,
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 40.0),
          height: widget.height + 54,
          color: Colors.red,
          child: CustomScrollView(
            physics: widget.lock ? NeverScrollableScrollPhysics() : null,
            slivers: [
              SliverAppBar(
                // title: Transform.translate(
                //   offset: Offset(0.0, -30.0),
                //   child: Text('title'),
                // ),
                backgroundColor: Colors.blue,
                titleSpacing: 0.0,
                // collapsedHeight: 1.0,
                expandedHeight: expandedHeight - 10.0,
                toolbarHeight: 0.0,
                elevation: 0.0,
                // pinned: true,
                floating: true,
                leading: null,
                forceElevated: false,
                automaticallyImplyLeading: false,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipRRect(
                      child: OverflowBox(
                        alignment: Alignment.topLeft,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 17.0,
                            ),
                            Text(widget.story.description,
                                key: _descriptionKey),
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
                                discussionBtn(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 22.0,
                          ),
                          Text('Comment $index'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.yellow,
            height: 40.0,
            child: Center(
              child: Text('Input box'),
            ),
          ),
        ),
      ],
    );
  }
}
