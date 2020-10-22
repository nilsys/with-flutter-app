import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/full-screen-media/full_screen_media.view.dart';

class DiscussionPost extends StatefulWidget {
  final Post post;

  DiscussionPost({
    @required this.post,
  });

  @override
  _DiscussionPostState createState() => _DiscussionPostState();
}

class _DiscussionPostState extends State<DiscussionPost>
    with TickerProviderStateMixin {
  final UserVM userProvider = locator<UserVM>();
  final StoryVM storyProvider = locator<StoryVM>();
  AnimationController animationController;
  bool _show = false;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: storyProvider.showDiscussion && _show ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(top: 32.0),
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
                      children: [
                        Avatar(
                          src: user.profileImage,
                          radius: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(user.displayName),
                        ),
                        Text(timeago.format(widget.post.createdAt)),
                      ],
                    );
                  }
                  return Spinner();
                }),
            Transform.translate(
              offset: Offset(0.0, -10.0),
              child: Container(
                margin: EdgeInsets.only(left: 55.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset:
                          Offset(0.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,
                            '${FullScreenMedia.route}/${Uri.encodeComponent(widget.post.media[0])}');
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
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(widget.post.text),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
