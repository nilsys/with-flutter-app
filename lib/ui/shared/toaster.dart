import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Toaster {
  final Icon icon;
  final Widget content;
  final String title;

  Toaster({
    @required this.icon,
    @required this.content,
    this.title,
  });

  void show(context) {
    Flushbar(
      titleText: this.title != null
          ? Text(
              this.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            )
          : null,
      icon: icon,
      messageText: content,
      duration: Duration(seconds: 6),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      borderRadius: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.easeOutCubic,
      barBlur: 10,
      backgroundColor: Colors.black.withAlpha(80),
    )..show(context);
  }
}
