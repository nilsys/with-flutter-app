import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

const double expandedHeight = 120.0;
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
              constraints.biggest.height - _paddingTop - _appBarHeight;
          final squeeze = _height / (expandedHeight - _appBarHeight);
          return Container(
            color: Colors.green,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.red,
                  child: Opacity(
                    opacity: 1 * squeeze,
                    child: Text('Lorem Ipsum'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
