import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraVM extends ChangeNotifier {
  List<CameraDescription> _camaras;
  CameraDescription _selectedCamera;
  int _selectedCameraIndex = 0;

  List<CameraDescription> get cameras => _camaras;
  int get selectedCameraIndex => _selectedCameraIndex;

  set cameras(List<CameraDescription> val) {
    _camaras = val;
    _selectedCamera = val[0];
    notifyListeners();
  }

  set selectedCameraIndex(int val) {
    _selectedCameraIndex = val;
    notifyListeners();
  }

  Future<List<CameraDescription>> getAvailableCameras() async {
    final List<CameraDescription> cameras = await availableCameras();
    return cameras;
  }
}
