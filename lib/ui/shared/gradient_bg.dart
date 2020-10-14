import 'package:flutter/material.dart';

class GradientBG extends StatelessWidget {
  final Widget child;

  GradientBG({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withRed(150)
              ],
            ),
          ),
        ),
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}
