import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:with_app/core/view_models/camera.vm.dart';
import 'package:with_app/core/view_models/main.vm.dart';
import 'package:with_app/core/view_models/story.vm.dart';

class CameraView extends StatefulWidget {
  static const String route = 'camera';

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with SingleTickerProviderStateMixin {
  CameraController cameraController;
  AnimationController _animationController;
  Animation<double> _offsetAnimation;
  final CameraVM cameraProvider = locator<CameraVM>();
  final MainVM mainProvider = locator<MainVM>();
  // bool _showCameraPreviewPrev = false;
  bool disposed = false;

  @override
  void initState() {
    cameraController =
        CameraController(cameraProvider.cameras[0], ResolutionPreset.medium);
    CameraLensDirection _direction = CameraLensDirection.back;
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _offsetAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    // storyProvider.addListener(() {
    //   if (disposed) {
    //     return;
    //   }
    //   if (storyProvider.showCameraPreview) {
    //     _animationController.forward();
    //   } else {
    //     _animationController.reverse();
    //   }
    // });
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   final StoryVM _storyProvider = Provider.of<StoryVM>(context, listen: true);
  //   print(_storyProvider.showCameraPreview);
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    disposed = true;
    cameraController.dispose();
    _animationController.dispose();
    // storyProvider.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final StoryVM storyProvider = locator<StoryVM>();

    // print('animation value: ${_animationController.value}');

    int getTurnFactor() {
      int turns;
      switch (mainProvider.oreintation) {
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Take a Photo',
          style: Theme.of(context).textTheme.headline2,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // body: AspectRatio(
      //   aspectRatio: cameraController.value.aspectRatio,
      //   child: CameraPreview(cameraController),
      // ),
      body: cameraController.value.isInitialized
          ? RotatedBox(
              quarterTurns: getTurnFactor(),
              child: Transform.scale(
                scale: 1 / cameraController.value.aspectRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
