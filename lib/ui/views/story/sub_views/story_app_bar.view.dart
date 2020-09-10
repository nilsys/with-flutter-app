import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:tinycolor/tinycolor.dart';

class StoryAppBar extends StatelessWidget {
  final String title;

  StoryAppBar({this.title});

  @override
  Widget build(context) {
    return AppBar(
      title: title != null
          ? Text(
              title,
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
    );
  }
}
