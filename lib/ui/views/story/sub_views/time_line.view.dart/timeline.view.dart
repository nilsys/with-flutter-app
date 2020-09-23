import 'package:floating_pullup_card/floating_layout.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'sub_views/post.view.dart';
import 'sub_views/timeline_hero.view.dart';
// import 'package:with_app/ui/views/home/home.view.dart';

class Timeline extends StatefulWidget {
  final Story story;
  final UserModel currentUser;
  final UserModel author;

  Timeline({
    Key key,
    this.story,
    this.currentUser,
    this.author,
  }) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  ScrollControl scrollController = ScrollControl();

  @override
  void initState() {
    super.initState();
    scrollController.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FloatingPullUpCardLayout(
        cardElevation: 24,
        borderRadius: BorderRadius.zero,
        dragHandleBuilder: (context, constraints, beingDragged) {
          return Container(
            height: 68.0,
            width: double.infinity,
            color: Theme.of(context).primaryColorLight,
            child: Text('Discussion... TBD'),
          );
        },
        body: Text('Helo', style: Theme.of(context).textTheme.bodyText1),
        child: Container(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(this.context).unfocus();
            },
            child: CustomScrollView(
              slivers: <Widget>[
                TimelineHero(
                  author: widget.author,
                  story: widget.story,
                  currentUser: widget.currentUser,
                ),
                // Skeleton(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        // color: Colors.green,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 22.0,
                            ),
                            PostCard(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
