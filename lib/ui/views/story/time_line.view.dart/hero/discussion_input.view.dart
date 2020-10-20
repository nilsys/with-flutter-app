import 'dart:math';
import 'package:flutter/material.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
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
  TextEditingController textController = TextEditingController();
  bool _inputIsValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Row(
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
                          Navigator.pushNamed(context, '${CameraView.route}');
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
                    onPressed: _inputIsValid
                        ? () async {
                            await storyProvider.addCommentToStoryDiscussion(
                                textController.value.text);
                            textController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _inputIsValid = false;
                            });
                          }
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
