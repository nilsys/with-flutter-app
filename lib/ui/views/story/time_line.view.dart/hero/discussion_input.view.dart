import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:with_app/core/view_models/camera.vm.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/views/camera/camera.view.dart';

class DiscussionIpnut extends StatefulWidget {
  final Function scrollToBottom;

  DiscussionIpnut({
    @required this.scrollToBottom,
  });

  @override
  _DiscussionIpnutState createState() => _DiscussionIpnutState();
}

class _DiscussionIpnutState extends State<DiscussionIpnut> {
  final StoryVM storyProvider = locator<StoryVM>();
  final CameraVM cameraProvider = locator<CameraVM>();
  TextEditingController textController = TextEditingController();
  bool _inputIsValid;

  @override
  void initState() {
    _inputIsValid = cameraProvider.filePath.length > 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<CameraVM>(context, listen: true);
    _inputIsValid = cameraProvider.filePath.length > 0 ||
        textController.value.text.trim().length > 0;
    if (cameraProvider.filePath.length !=
        cameraProvider.prevValues['fileCount']) {
      widget.scrollToBottom();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    cameraProvider.clearFiles();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void submit() async {
      await storyProvider.addCommentToStoryDiscussion(
          textController.value.text, cameraProvider.filePath);
      textController.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        _inputIsValid = false;
      });
    }

    return AnimatedOpacity(
      opacity: storyProvider.showDiscussion ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: KeyboardAware(
        builder: (context, keyboardConfig) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            storyProvider.keyboardIsOpen = keyboardConfig.isKeyboardOpen;
          });
          return Container(
            // duration:
            //     Duration(milliseconds: storyProvider.keyboardIsOpen ? 500 : 0),
            // curve: Curves.decelerate,
            margin: EdgeInsets.fromLTRB(
              0.0,
              25.0,
              0.0,
              max(0.0, keyboardConfig.keyboardHeight - 42.0),
            ),
            // keyboardConfig.isKeyboardOpen
            //     ? keyboardConfig.keyboardHeight - 42.0
            //     : 0.0),
            child: Column(
              children: [
                _thumbnailWidget(),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: textController,
                            maxLines: null,
                            // minLines: 3,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Theme.of(context).primaryColor,
                            onChanged: (String e) {
                              widget.scrollToBottom();
                              setState(() {
                                _inputIsValid =
                                    textController.value.text.trim().length > 0;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Add a comment...',
                              hintStyle: TextStyle(
                                color: Colors.black.withAlpha(100),
                              ),
                            ),
                          ),
                          IconButton(
                            splashRadius: 25.0,
                            onPressed: () {
                              // FocusScope.of(this.context).unfocus();
                              Navigator.pushNamed(
                                  context, '${CameraView.route}');
                              storyProvider.showCameraPreview = true;
                            },
                            icon: Icon(Icons.camera_alt_rounded),
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: IconButton(
                        splashRadius: 25.0,
                        padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                        icon: Icon(Icons.send_rounded),
                        onPressed: _inputIsValid ? submit : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @swidget
  Widget _thumbnailWidget() => Container(
        margin: EdgeInsets.only(bottom: 8.0),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: cameraProvider.filePath
              .map((path) => Dismissible(
                    key: Key(path),
                    direction: DismissDirection.up,
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
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(
                                File(path),
                              ),
                            ),
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
