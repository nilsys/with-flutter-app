import 'package:flutter/material.dart';
import 'dart:math';

class PostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Random random = new Random();

    return Container(
      height: random.nextDouble() * 250 + 10,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
      padding: EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: Text(
        '',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
