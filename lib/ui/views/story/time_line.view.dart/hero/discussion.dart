import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_utils/widgets.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/shared/all.dart';

class StoryDiscussion extends StatefulWidget {
  final Function scrollToBottom;

  StoryDiscussion({
    @required this.scrollToBottom,
  });

  @override
  _StoryDiscussionState createState() => _StoryDiscussionState();
}

class _StoryDiscussionState extends State<StoryDiscussion> {
  final StoryVM storyProvider = locator<StoryVM>();
  // Timer _timer;

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!storyProvider.keyboardIsOpen) {
    //   _timer = Timer(const Duration(milliseconds: 1000), () {
    //     FocusScope.of(context).unfocus();
    //   });
    // }

    return StreamBuilder<QuerySnapshot>(
        stream: storyProvider.streamDiscussion(),
        builder: (context, snapshot) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return snapshot.hasData && index < snapshot.data?.size
                    ? AnimatedOpacity(
                        opacity: storyProvider.showDiscussion ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 22.0,
                              ),
                              Text('asdfasd'),
                            ],
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: storyProvider.showDiscussion ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: KeyboardAware(
                          builder: (context, keyboardConfig) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              storyProvider.keyboardIsOpen =
                                  keyboardConfig.isKeyboardOpen;
                            });
                            return AnimatedContainer(
                              duration: Duration(
                                  milliseconds:
                                      storyProvider.keyboardIsOpen ? 500 : 0),
                              curve: Curves.decelerate,
                              margin: EdgeInsets.fromLTRB(
                                  0.0,
                                  25.0,
                                  0.0,
                                  keyboardConfig.isKeyboardOpen
                                      ? keyboardConfig.keyboardHeight - 42.0
                                      : 0.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      maxLines: null,
                                      // minLines: 3,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(color: Colors.black),
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      onChanged: (String e) {
                                        widget.scrollToBottom();
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
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    child: IconButton(
                                      splashRadius: 25.0,
                                      padding: EdgeInsets.fromLTRB(
                                          5.0, 0.0, 0.0, 0.0),
                                      icon: Icon(Icons.send_rounded),
                                      onPressed: () {
                                        print('add comment');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
              },
              childCount: snapshot.hasData ? snapshot.data.size + 1 : 1,
            ),
          );
        });
  }
}
