import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraVM extends ChangeNotifier {
  List<CameraDescription> _camaras;
  int _selectedCameraIndex = 0;
  List<String> _filePath = [];
  Map<String, dynamic> _prevValues = {
    'selectedCameraIndex': 0,
    'fileCount': 0,
  };

  List<CameraDescription> get cameras => _camaras;
  int get selectedCameraIndex => _selectedCameraIndex;
  Map<String, dynamic> get prevValues => _prevValues;
  List<String> get filePath => _filePath;

  set cameras(List<CameraDescription> val) {
    _camaras = val;
    notifyListeners();
  }

  set selectedCameraIndex(int val) {
    _prevValues['selectedCameraIndex'] = _selectedCameraIndex;
    _selectedCameraIndex = val;
    notifyListeners();
  }

  void storeFilePath(String path) {
    if (!_filePath.contains(path)) {
      _prevValues['fileCount'] = _filePath.length;
      _filePath.add(path);
      notifyListeners();
    }
  }

  void removeFilePath(String path) {
    if (_filePath.contains(path)) {
      _prevValues['fileCount'] = _filePath.length;
      _filePath.remove(path);
      notifyListeners();
    }
  }

  void reset() {
    _prevValues['selectedCameraIndex'] = _selectedCameraIndex;
  }

  void clearFiles() {
    _filePath = [];
    _prevValues['fileCount'] = 0;
  }

  Future<List<CameraDescription>> getAvailableCameras() async {
    final List<CameraDescription> cameras = await availableCameras();
    return cameras;
  }
}
