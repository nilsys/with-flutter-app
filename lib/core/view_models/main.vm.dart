import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class MainVM extends ChangeNotifier {
  NativeDeviceOrientation _orientation;
  bool _oreintationIsLandscape;

  NativeDeviceOrientation get oreintation => _orientation;
  bool get oreintationIsLandscape => _oreintationIsLandscape;

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
