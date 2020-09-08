import 'dart:async';

import 'package:flutter/material.dart';

class ScrollControl {
  ScrollController controller;

  init() {
    controller = ScrollController();
  }

  dispose() {
    controller.dispose();
  }

  void scrollToBottom() {
    Timer(Duration(milliseconds: 200), () {
      controller.animateTo(controller.position.maxScrollExtent,
          curve: Curves.linear, duration: Duration(milliseconds: 500));
    });
  }
}
