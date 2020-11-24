import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:with_app/core/view_models/camera.vm.dart';
import 'package:with_app/core/view_models/layout.vm.dart';
import 'package:with_app/core/view_models/story.vm.dart';

class CameraView extends StatefulWidget {
  static const String route = 'camera';

  @override
  _CameraViewState createState() {
    return _CameraViewState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  bool disableActionBtn = false;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CameraVM cameraProvider = locator<CameraVM>();
  final LayoutVM layoutProvider = locator<LayoutVM>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // TODO: learn about this...
    onNewCameraSelected(
        cameraProvider.cameras[cameraProvider.selectedCameraIndex]);
  }

  @override
  void didChangeDependencies() {
    Provider.of<CameraVM>(context, listen: true);
    if (cameraProvider.selectedCameraIndex !=
        cameraProvider.prevValues['selectedCameraIndex']) {
      onNewCameraSelected(
          cameraProvider.cameras[cameraProvider.selectedCameraIndex]);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraProvider.reset();
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: (layoutProvider.oreintation.index == 0)
            ? protraitLayout()
            : landscapeLayout(),
      ),
    );
  }

  @swidget
  Widget appBar() => SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Text(
                  'Take a Photo',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ],
            ),
          ),
        ),
      );

  List<Widget> protraitLayout() {
    return [
      Column(
        children: _cameraPreviewWidget(),
      ),
      Transform.translate(
        offset: Offset(-30.0, -130.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: _thumbnailWidget(),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: actionBtn(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: rotateBtn(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: galleryBtn(),
            ),
          ],
        ),
      ),
      appBar(),
    ];
  }

  List<Widget> landscapeLayout() {
    return [
      Column(
        children: _cameraPreviewWidget(landscape: true),
      ),
      SafeArea(
        child: Transform.translate(
          offset: Offset(25.0, 60.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: _thumbnailWidget(),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: actionBtn(),
            ),
            Transform.translate(
              offset: Offset(0.0, -100.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: rotateBtn(),
              ),
            ),
            Transform.translate(
              offset: Offset(0.0, 100.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: galleryBtn(),
              ),
            ),
          ],
        ),
      ),
      appBar(),
      // Align(
      //   alignment: Alignment.bottomRight,
      //   child:
      //       FloatingActionButton(child: Icon(Icons.portrait), onPressed: () {}),
      // ),
    ];
  }

  Widget actionBtn() {
    return SizedBox(
      width: 80,
      height: 80,
      child: FlatButton(
        onPressed: disableActionBtn ? null : onTakePictureButtonPressed,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).accentColor,
              width: 4,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(),
      ),
    );
  }

  Widget rotateBtn() {
    return SizedBox(
      width: 80,
      height: 80,
      child: FlatButton(
        onPressed: () {
          cameraProvider.selectedCameraIndex =
              cameraProvider.selectedCameraIndex == 0 ? 1 : 0;
          // controller != null && controller.value.isRecordingVideo
          //     ? null
          //     : onNewCameraSelected(cameraProvider.cameras[1]);
        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0),
        ),
        child: Icon(
          Icons.flip_camera_ios_outlined,
          size: 42.0,
        ),
      ),
    );
  }

  Future _getImageFromGallery() async {
    var pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50, // do 100 for max quality
    );
    if (pickedFile != null) {
      cameraProvider.storeFilePath(pickedFile.path);
    }
  }

  Widget galleryBtn() {
    return SizedBox(
      width: 80,
      height: 80,
      child: FlatButton(
        onPressed: _getImageFromGallery,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0),
        ),
        child: Icon(
          Icons.collections_outlined,
          size: 42.0,
        ),
      ),
    );
  }

  int getTurnFactor() {
    int turns;
    switch (layoutProvider.oreintation) {
      case NativeDeviceOrientation.landscapeLeft:
        turns = -1;
        break;
      case NativeDeviceOrientation.landscapeRight:
        turns = 1;
        break;
      case NativeDeviceOrientation.portraitDown:
        turns = 2;
        break;
      default:
        turns = 0;
        break;
    }
    return turns;
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  List<Widget> _cameraPreviewWidget({bool landscape = false}) {
    if (!controller.value.isInitialized) {
      return const [
        Text(
          'Initializing Camera...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        )
      ];
    } else {
      int turnFactor = getTurnFactor();
      return <Widget>[
        Expanded(
          child: RotatedBox(
            quarterTurns: turnFactor,
            child: Transform.scale(
              // scale: 1 / controller.value.aspectRatio,
              scale: turnFactor.abs() == 1 ? 2.1 : 1.3,
              // scale: 1,
              child: Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
              ),
            ),
          ),
        ),
        // _captureControlRowWidget(),
        // _toggleAudioWidget(),
        // landscape
        //     ? Container(
        //         width: 100.0,
        //         child: _thumbnailWidget(),
        //       )
        //     : Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: <Widget>[
        //           // _cameraTogglesRowWidget(),
        //           _thumbnailWidget(),
        //         ],
        //       ),
      ];
    }
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: <Widget>[
          const Text('Enable Audio:'),
          Switch(
            value: enableAudio,
            onChanged: (bool value) {
              enableAudio = value;
              if (controller != null) {
                onNewCameraSelected(controller.description);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Container(
      width: 70.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: cameraProvider.filePath
            .map((path) => Dismissible(
                  key: Key(path),
                  direction: layoutProvider.oreintationIsLandscape
                      ? DismissDirection.endToStart
                      : DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    cameraProvider.removeFilePath(path);
                    print('dismissed');
                  },
                  background: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Center(
                      child: Icon(
                        Icons.delete_sweep,
                        color: Colors.red,
                        size: 34.0,
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //   color: Colors.red,
                    //   borderRadius: BorderRadius.circular(50),
                    //   border: Border.all(color: Colors.pink, width: 2.0),
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
                    child: SizedBox(
                      child: (videoController == null)
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 2.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.file(
                                    File(path),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.green,
                              child: Center(
                                child: AspectRatio(
                                    aspectRatio:
                                        videoController.value.size != null
                                            ? videoController.value.aspectRatio
                                            : 1.0,
                                    child: VideoPlayer(videoController)),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.pink, width: 2.0),
                              ),
                            ),
                      width: 64.0,
                      height: 64.0,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: controller != null && controller.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? (controller != null && controller.value.isRecordingPaused
                  ? onResumeButtonPressed
                  : onPauseButtonPressed)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        )
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (cameraProvider.cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      return FloatingActionButton(
          child: Icon(Icons.portrait), onPressed: () {});
      // for (CameraDescription cameraDescription in cameraProvider.cameras) {
      //   toggles.add(
      //     SizedBox(
      //       width: 90.0,
      //       child: RadioListTile<CameraDescription>(
      //         title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
      //         groupValue: controller?.description,
      //         value: cameraDescription,
      //         onChanged: controller != null && controller.value.isRecordingVideo
      //             ? null
      //             : onNewCameraSelected,
      //       ),
      //     ),
      //   );
      // }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null && mounted) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    setState(() {
      disableActionBtn = true;
    });
    takePicture().then((String filePath) {
      if (mounted) {
        cameraProvider.storeFilePath(filePath);
        setState(() {
          imagePath = filePath; // TODO:: remove this line
          videoController?.dispose();
          videoController = null;
          disableActionBtn = false;
        });
        // if (filePath != null) showInSnackBar('Saved!');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  void _saveNetworkImage(String filePath) async {
    GallerySaver.saveImage(filePath).then((bool success) {
      setState(() {
        print('Image is saved');
      });
    });
  }

  void _saveNetworkVideo(String filePath) async {
    GallerySaver.saveVideo(filePath).then((bool success) {
      setState(() {
        print('Video is saved');
      });
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/withapp';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
      _saveNetworkImage(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
