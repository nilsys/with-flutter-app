import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:with_app/ui/shared/all.dart';

const double expandedHeight = 150.0;
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

    return SliverAppBar(
      centerTitle: true,
      title: widget.story != null
          ? Text(
              widget.story.title,
              style: TextStyle(
                fontSize: 20.0,
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
              baseColor: TinyColor(Theme.of(context).primaryColorLight)
                  .lighten(4)
                  .color,
              hightlightColor: TinyColor(Theme.of(context).primaryColorLight)
                  .lighten(10)
                  .color,
            ),
      backgroundColor: Theme.of(context).primaryColorLight,
      expandedHeight: expandedHeight,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.more_vert),
          tooltip: 'Open shopping cart',
          onPressed: () {
            widget.scaffoldKey.currentState.openEndDrawer();
          },
        ),
      ],
      // collapsedHeight: collapsedHeight,
      pinned: true,
      toolbarHeight: 55.0,
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
          final squeeze = _height / (expandedHeight - _appBarHeight);
          return Container(
            // color: Colors.green,
            height: double.infinity,
            child: Opacity(
              opacity: 1 * squeeze,
              child: Transform.scale(
                scale: 1 * squeeze,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: widget.user != null
                      ? [
                          Avatar(
                            src: widget.user.profileImage,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(widget.user.displayName),
                          ),
                        ]
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
          );
        },
      ),
    );
  }
}
