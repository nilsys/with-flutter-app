import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Toaster {
  final Icon icon;
  final Widget content;

  Toaster({
    @required this.icon,
    @required this.content,
  });

  void show(context) {
    Flushbar(
      // titleText: Text("Oops..."),
      icon: icon,
      messageText: content,
      duration: Duration(seconds: 6),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 84),
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
