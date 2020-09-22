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
import 'package:with_app/ui/shared/all.dart';

const double expandedHeight = 280.0;
const double collapsedHeight = 90.0;

class TimelineHero extends StatefulWidget {
  final UserModel user;
  final Story story;
  final GlobalKey<ScaffoldState> scaffoldKey;

  TimelineHero({
    this.user,
    this.story,
    @required this.scaffoldKey,
  });

  @override
  _TimelineHeroState createState() => _TimelineHeroState();
}

class _TimelineHeroState extends State<TimelineHero> {
  bool _isCollapsed = false;
  bool sharing = false;

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
          Text(name),
        ],
      );
    }

    @swidget
    Widget flexibleContainer(List<Widget> children, double squeeze) {
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
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 26.0),
              color: Theme.of(context).primaryColorLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.story != null
                    ? children
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

    List<Widget> flexibleContent = [
      Text(
        widget.story.title,
        style: Theme.of(context).textTheme.headline1,
      ),
      Text(widget.story.description),
      SizedBox(
        height: 24.0,
      ),
      Divider(
        height: 0.0,
        color: Colors.white.withOpacity(0.5),
      ),
      SizedBox(
        height: 10.0,
      ),
      stats,
    ];

    Widget title = widget.user != null
        ? Transform.translate(
            offset: Offset(-15.0, 0.0),
            child: _isCollapsed
                ? Text(
                    widget.story.title,
                    style: Theme.of(context).textTheme.headline2,
                  )
                : Row(
                    mainAxisAlignment: _isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Avatar(
                        src: widget.user.profileImage,
                        radius: 18.0,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        widget.user.displayName,
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
        child: FlatButton(
          child: Row(
            children: [
              SizedBox(
                width: 5.0,
              ),
              Icon(iconData),
              SizedBox(
                width: 15.0,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
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
      // centerTitle: _isCollapsed,
      backgroundColor: Theme.of(context).primaryColorLight.darken(),
      expandedHeight: expandedHeight,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.more_vert),
          tooltip: 'Open shopping cart',
          onPressed: () {
            // widget.scaffoldKey.currentState.openEndDrawer();
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      listItem('Settings', Icons.settings, () {}),
                      listItem('Share', Icons.share,
                          sharing == false ? shareStoryLink : null),
                    ],
                  );
                });
          },
        ),
      ],
      // collapsedHeight: collapsedHeight,
      pinned: true,
      // toolbarHeight: 55.0,
      // flexibleSpace: OverflowBox(
      //   child: Container(
      //     color: Colors.green,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         Text('Hi'),
      //       ],
      //     ),
      //     height: expandedHeight + _paddingTop,
      //   ),
      // ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final _height =
              max(constraints.biggest.height - _paddingTop - _appBarHeight, 0);
          if (_height == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isCollapsed = true;
              });
            });
          } else if (_isCollapsed == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isCollapsed = false;
              });
            });
          }
          final squeeze = _height / (expandedHeight - _appBarHeight);
          return flexibleContainer(
            flexibleContent,
            squeeze,
          );
        },
      ),
    );
  }
}
