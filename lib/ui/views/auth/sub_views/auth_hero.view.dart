import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:with_app/ui/shared/all.dart';

class AuthHero extends StatelessWidget {
  final String text;

  AuthHero({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpacer(
          multiplier: 4,
        ),
        SvgPicture.asset(
          'images/logo_light.svg',
          semanticsLabel: 'With Logo',
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          key: Key('hero_header'),
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
