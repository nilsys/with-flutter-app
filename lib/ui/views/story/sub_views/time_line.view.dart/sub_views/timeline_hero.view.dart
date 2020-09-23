import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fade/fade.dart';
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

class TimelineHero extends StatefulWidget {
  final UserModel author;
  final Story story;
  final UserModel currentUser;

  TimelineHero({
    this.author,
    this.story,
    this.currentUser,
  });

  @override
  _TimelineHeroState createState() => _TimelineHeroState();
}

class _TimelineHeroState extends State<TimelineHero> {
  bool _isCollapsed = false;
  bool sharing = false;
  GlobalKey _descriptionKey = GlobalKey();
  double expandedHeight = 0.0;
  double descriptionHeight = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  SliverAppBar build(context) {
    final double _paddingTop = MediaQuery.of(context).padding.top;
    final double _appBarHeight = AppBar().preferredSize.height;
    final storyProvider = Provider.of<StoryVM>(context);
    final userProvider = Provider.of<UserVM>(context);
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
      final _descriptionBox = keyContext.findRenderObject() as RenderBox;
      final double newHeight = _descriptionBox.size.height;
      if (newHeight != descriptionHeight) {
        setState(() {
          expandedHeight = 268.0 + _descriptionBox.size.height;
          descriptionHeight = _descriptionBox.size.height;
        });
      }
    });

    @swidget
    Widget counter(String name, num val) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toCurrencyString(
              '$val',
              mantissaLength: 0,
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 0.6,
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(name),
        ],
      );
    }

    Widget stats = Padding(
      padding: EdgeInsets.fromLTRB(8.0, 22.0, 8.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          counter('posts', widget.story.posts),
          Spacer(),
          counter('followers', widget.story.followers.length),
          Spacer(),
          counter('views', widget.story.views),
          Spacer(
            flex: 5,
          ),
          Transform.translate(
            offset: Offset(0.0, -4.0),
            child: Row(
              children: [
                Icon(widget.story.private
                    ? Icons.supervised_user_circle
                    : Icons.public),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  widget.story.private ? 'Private' : 'Public',
                )
              ],
            ),
          )
        ],
      ),
    );

    @swidget
    Widget followBtn(bool condensed) {
      String exsistingId = widget.currentUser.stories.following.firstWhere(
        (element) => element == widget.story.id,
        orElse: () => null,
      );
      return condensed
          ? InkWell(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Fade(
                  visible: _isCollapsed,
                  child: Transform.translate(
                    offset: Offset(0.0, -3.0),
                    child: Icon(
                      exsistingId == null
                          ? Icons.bookmark_border
                          : Icons.bookmark,
                      size: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              onTap: exsistingId == null ? followStory : unFollowStory,
            )
          : SizedBox(
              height: 34.0,
              width: exsistingId == null ? 110.0 : 130.0,
              child: RaisedButton(
                textColor: Theme.of(context).primaryColorLight,
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
                onPressed: exsistingId == null ? followStory : unFollowStory,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      exsistingId == null
                          ? Icons.bookmark_border
                          : Icons.bookmark,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      exsistingId == null ? 'FOLLOW' : 'FOLLOWING',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
    }

    List<Widget> flexibleContent = [
      SizedBox(
        width: MediaQuery.of(context).size.width - 60.0,
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
      Text(widget.story.description, key: _descriptionKey),
      SizedBox(
        height: 18.0,
      ),
      followBtn(false),
      SizedBox(
        height: 24.0,
      ),
      Divider(
        height: 0.0,
        color: Colors.white.withOpacity(0.3),
        thickness: 1.0,
      ),
      stats,
    ];

    @swidget
    Widget flexibleContainer(double squeeze) {
      return Opacity(
        opacity: 1 * squeeze,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topLeft,
            minHeight: 0.0,
            maxHeight: double.infinity,
            child: Container(
              margin: EdgeInsets.only(top: _paddingTop + _appBarHeight),
              // height: expandedHeight,
              padding: const EdgeInsets.fromLTRB(22.0, 16.0, 22.0, 26.0),
              color: Theme.of(context).primaryColorLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.story != null
                    ? flexibleContent
                    : [
                        SkeletonLoader(
                          builder: Column(
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                margin: EdgeInsets.only(bottom: 5.0),
                                decoration: new BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                color: Colors.black,
                                width: 160.0,
                                height: 18.0,
                                margin: EdgeInsets.only(bottom: 15.0),
                              ),
                            ],
                          ),
                          items: 1,
                          period: Duration(seconds: 2),
                          baseColor:
                              TinyColor(Theme.of(context).primaryColorLight)
                                  .lighten(4)
                                  .color,
                          hightlightColor:
                              TinyColor(Theme.of(context).primaryColorLight)
                                  .lighten(10)
                                  .color,
                        ),
                      ],
              ),
            ),
          ),
        ),
      );
    }

    Widget title = widget.author != null
        ? Transform.translate(
            offset: Offset(-15.0, 0.0),
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
                TinyColor(Theme.of(context).primaryColorLight).lighten(4).color,
            hightlightColor: TinyColor(Theme.of(context).primaryColorLight)
                .lighten(10)
                .color,
          );

    @swidget
    Widget listItem(String text, IconData iconData, Function onPressed) {
      return SizedBox(
        width: double.infinity,
        child: OutlineButton(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: onPressed,
        ),
      );
    }

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

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: title,
      backgroundColor: Theme.of(context).primaryColorLight.darken(),
      expandedHeight: expandedHeight,
      actions: [
        followBtn(true),
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
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.4,
                    child: Container(
                      color: Theme.of(context).primaryColorLight,
                      padding: EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          listItem('SETTINGS', Icons.settings, () {}),
                          SizedBox(
                            height: 15.0,
                          ),
                          listItem('SHARE', Icons.share,
                              sharing == false ? shareStoryLink : null),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ],
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final _height =
              max(constraints.biggest.height - _paddingTop - _appBarHeight, 0);
          if (_height == 0) {
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
          final squeeze = _height / (expandedHeight - _appBarHeight);
          return flexibleContainer(
            squeeze,
          );
        },
      ),
    );
  }
}
