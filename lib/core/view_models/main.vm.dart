import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class MainVM extends ChangeNotifier {
  NativeDeviceOrientation _orientation;

  NativeDeviceOrientation get oreintation => _orientation;

  set oreintation(val) {
    _orientation = val;
    notifyListeners();
  }
}
