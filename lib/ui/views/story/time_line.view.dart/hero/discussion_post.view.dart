import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/full-screen-media/full_screen_media.view.dart';

class DiscussionPost extends StatefulWidget {
  final DateFormat formatter = DateFormat('Hm');
  final Post post;
  final ScrollController scrollController;
  final int index;

  DiscussionPost({
    @required this.post,
    @required this.scrollController,
    @required this.index,
  });

  @override
  _DiscussionPostState createState() => _DiscussionPostState();
}

class _DiscussionPostState extends State<DiscussionPost>
    with TickerProviderStateMixin {
  final UserVM userProvider = locator<UserVM>();
  final StoryVM storyProvider = locator<StoryVM>();
  GlobalKey _postKey = GlobalKey();
  AnimationController animationController;
  bool _show = false;
  bool _showNewPostTag = false;
  DateTime _lastEntry;

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      setState(() {
        _show = true;
      });
    });
    if (userProvider.user.logs != null &&
        userProvider.user.logs[storyProvider.story.id] != null) {
      var _t = userProvider.user.logs[storyProvider.story.id];
      if (_t is Timestamp) {
        _lastEntry = (userProvider.user.logs[storyProvider.story.id]).toDate();
      } else if (_t is DateTime) {
        _lastEntry = _t;
      }
      if (widget.post.createdAt.compareTo(_lastEntry) > 0) {
        storyProvider.hasNewComments = true;
        _showNewPostTag = true;
      }
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final keyContext = _postKey.currentContext;
    //   if (keyContext != null) {
    //     final _box = keyContext.findRenderObject() as RenderBox;
    //     storyProvider.setScrollOffset(widget.index, _box.size.height);
    //     // print('index: ${widget.index}, height: ${_box.size.height}');
    //   }
    // });
    super.initState();
  }

  @swidget
  Widget _newPostTag() => AnimatedContainer(
        curve: Curves.easeInOutQuad,
        duration: Duration(milliseconds: 500),
        height: _showNewPostTag ? 13.0 : 0.0,
        width: _showNewPostTag ? 13.0 : 0.0,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      );

  @swidget
  Widget imgBox() => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GestureDetector(
          onTap: () {
            List<String> encodedURis = widget.post.media
                .map((uri) => Uri.encodeComponent(uri))
                .toList();
            String images = encodedURis.join('/');
            Navigator.pushNamed(context, '${FullScreenMedia.route}/$images');
          },
          child: CachedNetworkImage(
            imageUrl: widget.post.media[0],
            imageBuilder: (context, imageProvider) => Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: widget.post.media.length > 1
                  ? Transform.translate(
                      offset: Offset(-10.0, -10.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: 18.0,
                            ),
                            Text(
                              '${widget.post.media.length - 1}',
                              style: Theme.of(context).textTheme.headline3,
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = BoxDecoration(
      color: Theme.of(context).primaryColorLight,
      borderRadius: BorderRadius.circular(5.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(70),
          blurRadius: 3.0,

          spreadRadius: 0.0,
          offset: Offset(0.0, 1.0), // shadow direction: bottom right
        ),
      ],
      border: Border.all(
        color: Colors.white24,
        width: 1.0,
      ),
    );

    return AnimatedOpacity(
      opacity: storyProvider.showDiscussion && _show ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: VisibilityDetector(
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          // print('Widget ${widget.index} is ${visiblePercentage}% visible');
        },
        key: _postKey,
        child: Container(
          padding: EdgeInsets.only(top: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: userProvider.getUserById(widget.post.author),
                builder: (_, snapshot) {
                  if (snapshot.data != null) {
                    UserModel user = UserModel.fromMap(
                        snapshot.data.data(), widget.post.author);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Avatar(
                          src: user.profileImage,
                          radius: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(user.displayName),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, top: 6.0),
                          child: _newPostTag(),
                        ),
                      ],
                    );
                  }
                  return Spinner();
                },
              ),
              Transform.translate(
                offset: Offset(0.0, -10.0),
                child: Container(
                  margin: EdgeInsets.only(left: 55.0),
                  padding:
                      widget.post.media.length > 0 ? EdgeInsets.all(8.0) : null,
                  width: widget.post.media.length > 0
                      ? MediaQuery.of(context).size.width * 0.5
                      : null,
                  decoration:
                      widget.post.media.length > 0 ? boxDecoration : null,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.post.media.length > 0 ? imgBox() : Container(),
                          Container(
                            padding: widget.post.media.length == 0
                                ? EdgeInsets.all(8.0)
                                : null,
                            decoration: widget.post.media.length == 0
                                ? boxDecoration
                                : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.text,
                                  style: TextStyle(
                                      // color: Theme.of(context).primaryColorDark,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Transform.translate(
                                          offset: Offset(0.0, 1.0),
                                          child: Icon(
                                            Icons.access_time,
                                            size: 18.0,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            widget.formatter
                                                .format(widget.post.createdAt),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
