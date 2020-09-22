import 'dart:math';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter/material.dart';
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
          Text(toCurrencyString(
            '$val',
            mantissaLength: 0,
          )),
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
      padding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
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
          Container(
            margin: EdgeInsets.only(top: 3.0),
            padding: const EdgeInsets.fromLTRB(
              15.0,
              5.0,
              15.0,
              7.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
            child: Text(
              widget.story.private ? 'Private' : 'Public',
            ),
          )
        ],
      ),
    );

    List<Widget> flexibleContent = [
      Text(
        widget.story.title,
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(widget.story.description),
      SizedBox(
        height: 20.0,
      ),
      Divider(
        height: 0.0,
        color: Colors.white.withOpacity(0.5),
      ),
      stats,
    ];

    Widget title = widget.user != null
        ? Transform.translate(
            offset: Offset(_isCollapsed ? 0.0 : -15.0, 0.0),
            child: _isCollapsed
                ? Text(
                    widget.story.title,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
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

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: title,
      centerTitle: _isCollapsed,
      backgroundColor: Theme.of(context).primaryColorLight.darken(),
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
