import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:share/share.dart';
// import 'sub_views/story_footer.view.dart';
import 'sub_views/story_settings.view.dart/story_settings.view.dart';
import 'sub_views/time_line.view.dart/timeline.view.dart';

class StoryView extends StatefulWidget {
  static const String route = 'story';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final String id;

  StoryView({
    @required this.id,
  });

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final _pageController = PageController(
    initialPage: 0,
  );
  bool sharing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryVM>(context);
    Story story;

    return Scaffold(
      key: widget._key,
      backgroundColor: Theme.of(context).backgroundColor,
      endDrawer: Container(
        width: 200.0,
        child: Drawer(
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 40.0),
            color: Theme.of(context).primaryColorLight.darken(),
            child: Column(
              children: [
                listItem('Settings', Icons.settings, () {}),
                listItem(
                    'Share',
                    Icons.share,
                    sharing == false
                        ? () async {
                            final DynamicLinkParameters parameters =
                                DynamicLinkParameters(
                              uriPrefix: 'https://withapp.page.link',
                              link: Uri.parse(
                                  'https://withapp.io/go-to-story?id=${story.id}'),
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
                                title: story.title,
                                description:
                                    'This story was created on with-app',
                              ),
                            );
                            final ShortDynamicLink shortDynamicLink =
                                await parameters.buildShortLink();
                            final Uri shortUrl = shortDynamicLink.shortUrl;
                            print(shortUrl);
                            // final Uri dynamicUrl = await parameters.buildUrl();
                            if (sharing == false) {
                              Share.share('Check out my story\n\n$shortUrl',
                                  subject: story.title);
                            }
                            setState(() {
                              sharing = true;
                            });
                            Timer(Duration(milliseconds: 1000), () {
                              setState(() {
                                sharing = false;
                              });
                            });
                          }
                        : null),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: storyProvider.fetchStoryAsStream(widget.id),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              story = Story.fromMap(snapshot.data.data(), widget.id);
              return PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  Timeline(
                    story: story,
                    scaffoldKey: widget._key,
                  ),
                  StorySettings(),
                ],
              );
            }
            return Center(
              child: Spinner(),
            );
          }),
      // bottomNavigationBar: StoryFooter(
      //   onChange: (pageIndex) {
      //     _pageController.animateToPage(
      //       pageIndex,
      //       duration: Duration(milliseconds: 400),
      //       curve: Curves.easeInOutCubic,
      //     );
      //   },
      // ),
    );
  }
}
