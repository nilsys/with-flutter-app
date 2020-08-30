import 'package:flutter/material.dart';

class StyleGuide extends InheritedWidget {
  static StyleGuide of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StyleGuide>();

  const StyleGuide({Widget child, Key key}) : super(key: key, child: child);

  static const EdgeInsets pageBleed = EdgeInsets.fromLTRB(30, 40, 30, 0);

  @override
  bool updateShouldNotify(StyleGuide oldWidget) => false;
}
