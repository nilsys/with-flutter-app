import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double multiplier;

  VerticalSpacer({
    this.multiplier = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: multiplier * 12,
    );
  }
}
