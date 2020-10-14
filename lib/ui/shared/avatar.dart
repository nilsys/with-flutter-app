import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String src;
  final double radius;

  Avatar({
    @required this.src,
    this.radius = 25.0,
  });

  @override
  Widget build(context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white.withAlpha(150),
        child: ClipOval(
          child: Image.network(
            src,
            fit: BoxFit.cover,
            width: (radius * 2) - 3,
            height: (radius * 2) - 3,
          ),
        ),
      ),
    );
  }
}
