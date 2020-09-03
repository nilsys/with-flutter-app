import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          spinnerMode: true,
          size: 80,
          // trackWidth: 0,
          customColors: CustomSliderColors(
            trackColor: Colors.white.withAlpha(0),
            progressBarColors: [
              Theme.of(context).accentColor.withAlpha(0),
              Theme.of(context).accentColor.withAlpha(125),
              Theme.of(context).accentColor,
            ],
            shadowColor: Theme.of(context).accentColor,
            shadowMaxOpacity: 0.2,
          ),
          customWidths: CustomSliderWidths(
            trackWidth: 0,
            progressBarWidth: 5,
            handlerSize: 0,
          ),
        ),
      ),
    );
  }
}
