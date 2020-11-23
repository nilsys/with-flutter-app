import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
export 'package:provider/provider.dart';
export 'package:with_app/locator.dart';

class LayoutVM extends ChangeNotifier {
  NativeDeviceOrientation _orientation;
  bool _oreintationIsLandscape;
  double _gutter = 16.0;

  NativeDeviceOrientation get oreintation => _orientation;
  bool get oreintationIsLandscape => _oreintationIsLandscape;
  double get gutter => _gutter;

  set oreintation(val) {
    _orientation = val;
    if (val == NativeDeviceOrientation.landscapeLeft ||
        val == NativeDeviceOrientation.landscapeRight) {
      _oreintationIsLandscape = true;
    } else {
      _oreintationIsLandscape = false;
    }
    notifyListeners();
  }
}
