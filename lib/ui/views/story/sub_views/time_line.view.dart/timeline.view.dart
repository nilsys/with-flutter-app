import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_pullup_card/floating_layout.dart';
import 'package:floating_pullup_card/pullup_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'sub_views/post.view.dart';
import 'sub_views/timeline_hero.view.dart';
// import 'package:with_app/ui/views/home/home.view.dart';

class Timeline extends StatefulWidget {
  final Story story;

  Timeline({
    Key key,
    @required this.story,
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
    final _auth = FirebaseAuth.instance;
    final uid = _auth.currentUser.uid;
    final userProvider = Provider.of<UserVM>(context);
    //
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
            child: StreamBuilder<DocumentSnapshot>(
                stream: userProvider.fetchUserAsStream(widget.story.owner),
                builder: (context, snapshot) {
                  UserModel user;
                  if (snapshot.hasData) {
                    user = UserModel.fromMap(
                        snapshot.data.data(), widget.story.owner);
                  }
                  return CustomScrollView(
                    slivers: <Widget>[
                      TimelineHero(
                        user: user,
                        story: widget.story,
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
                  );
                }),
          ),
        ),
      ),
    );
  }
}
