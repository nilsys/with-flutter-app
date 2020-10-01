import 'dart:async';
import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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

class TimelineHero extends StatefulWidget {
  final UserModel author;
  final Story story;
  final UserModel currentUser;
  final ScrollController scrollController;

  TimelineHero({
    this.author,
    this.story,
    this.currentUser,
    this.scrollController,
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
  bool showDiscussion = false;

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
    bool isAuthor = widget.author?.id == widget.currentUser?.id;
    bool isFollower =
        widget.currentUser.stories.following.contains(widget.story.id);
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
          final staticHeight = isAuthor ? 228.0 : 258.0;
          setState(() {
            expandedHeight = staticHeight + _descriptionBox.size.height;
            descriptionHeight = _descriptionBox.size.height;
          });
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
            Text(name),
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
          Spacer(),
          Row(
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
          )
        ],
      ),
    );

    @swidget
    Widget followBtnState(bool follow, int valueKey) {
      return SizedBox(
        key: ValueKey(valueKey),
        height: 34.0,
        width: follow ? 110.0 : 130.0,
        child: RaisedButton(
          textColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
          onPressed: follow ? followStory : unFollowStory,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                follow ? Icons.bookmark_border : Icons.bookmark,
                size: 20.0,
              ),
              SizedBox(
                width: 6.0,
              ),
              Text(
                follow ? 'FOLLOW' : 'UNFOLLOW',
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

    @swidget
    actionBtn(Function onPressed, IconData iconData, String label,
        {Color iconColor = Colors.white}) {
      return Container(
        margin: EdgeInsets.only(right: 13.0),
        child: OutlineButton(
          onPressed: onPressed,
          highlightedBorderColor: Colors.white,
          borderSide: BorderSide(
            color: Colors.white, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
          child: Row(
            children: [
              Icon(iconData, size: 20.0, color: iconColor),
              SizedBox(
                width: 6.0,
              ),
              Text(
                label,
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

    @swidget
    Widget followBtn() {
      return actionBtn(
        isFollower ? unFollowStory : followStory,
        isFollower ? Icons.bookmark : Icons.bookmark_border,
        isFollower ? 'UNFOLLOW' : 'FOLLOW',
        iconColor: isFollower ? Theme.of(context).accentColor : Colors.white,
      );
    }

    @swidget
    Widget settingsBtn() {
      return actionBtn(() {}, With.settings, 'SETTINGS');
    }

    @swidget
    Widget shareBtn() {
      return actionBtn(() {}, Icons.share, 'SHARE');
    }

    @swidget
    Widget discussionBtn() {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          splashColor: Colors.white.withAlpha(50),
          // highlightColor: Colors.white,
          icon: Icon(Icons.mode_comment),
          onPressed: () {
            setState(() {
              // expandedHeight = staticHeight + _descriptionBox.size.height;
              // expandedHeight = expandedHeight + 200;
              showDiscussion = true;
            });
          },
          color: Theme.of(context).accentColor,
          iconSize: 30.0,
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
      stats,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isAuthor ? SizedBox() : followBtn(),
          settingsBtn(),
          Spacer(),
          discussionBtn(),
          // shareBtn(),
        ],
      ),
      SizedBox(
        height: 24.0,
      ),
    ];

    @swidget
    Widget flexibleContainer(double squeeze) {
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
              // height: expandedHeight,
              padding: const EdgeInsets.fromLTRB(22.0, 16.0, 22.0, 26.0),
              color: Theme.of(context).primaryColor,
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
                          baseColor: TinyColor(Theme.of(context).primaryColor)
                              .lighten(4)
                              .color,
                          hightlightColor:
                              TinyColor(Theme.of(context).primaryColor)
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              // transitionBuilder: (Widget child, Animation<double> animation) =>
              //     ScaleTransition(
              //   scale: animation,
              //   child: child,
              // ),
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
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
      // ),
      backgroundColor: Theme.of(context).primaryColor.darken(),
      expandedHeight: expandedHeight,
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
