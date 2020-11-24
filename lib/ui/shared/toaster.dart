import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar flushbar;

class Toaster {
  final Icon icon;
  final Widget content;
  final String title;
  final String type;

  Toaster({
    @required this.icon,
    @required this.content,
    this.type = 'info',
    this.title,
  });

  Color _getBackgroundColor() {
    switch (this.type) {
      case 'error':
        return Colors.red.withAlpha(40);
        break;
      default:
        return Colors.black.withAlpha(40);
    }
  }

  void show(context) {
    flushbar?.dismiss();
    flushbar = Flushbar(
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
      shouldIconPulse: false,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.easeOutCubic,
      barBlur: 10,
      backgroundColor: _getBackgroundColor(),
    )..show(context);
  }
}
