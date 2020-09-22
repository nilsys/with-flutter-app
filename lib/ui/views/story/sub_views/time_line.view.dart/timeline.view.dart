import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'sub_views/timeline_hero.view.dart';
// import 'package:with_app/ui/views/home/home.view.dart';

class Timeline extends StatefulWidget {
  final Story story;
  final GlobalKey<ScaffoldState> scaffoldKey;

  Timeline({
    Key key,
    @required this.story,
    @required this.scaffoldKey,
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(this.context).unfocus();
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: userProvider.fetchUserAsStream(uid),
          builder: (context, snapshot) {
            UserModel user;
            if (snapshot.hasData) {
              user = UserModel.fromMap(snapshot.data.data(), uid);
            }
            return CustomScrollView(
              slivers: <Widget>[
                TimelineHero(
                  user: user,
                  story: widget.story,
                  scaffoldKey: widget.scaffoldKey,
                ),
                // Skeleton(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              'Timeline Posts',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
