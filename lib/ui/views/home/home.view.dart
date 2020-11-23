import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/auth/auth.view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sub_views/story_card.view.dart';

class HomeView extends StatefulWidget {
  static const String route = 'home';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Story> stories;
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserVM userProvider = locator<UserVM>();
  final storyProvider = locator<StoryVM>();
  StreamSubscription<QuerySnapshot> storiesStream;

  @override
  void initState() {
    super.initState();
    storiesStream =
        storyProvider.fetchStoriesAsStream().listen((QuerySnapshot data) {
      storyProvider.storyList = data.docs.map((doc) {
        // if (doc.data()['timestamp'].toData().isAfter(userProvider.user.logs[storyProvider.story.id].toDate())) {

        // }
        return Story.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  void dispose() {
    storiesStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userProvider.fetchCurrentUserAsStream().listen((DocumentSnapshot doc) {
      userProvider.user = UserModel.fromMap(doc.data(), doc.id);
    });

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/addStory');
      //   },
      //   child: Icon(Icons.add),
      // ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Logged in as ${_auth.currentUser.email}'),
        leading: IconButton(
          iconSize: 19,
          icon: Icon(
            Icons.power_settings_new,
          ),
          onPressed: () async {
            await _googleSignIn.disconnect();
            await _auth.signOut();
            Navigator.pushNamed(context, AuthView.route);
          },
        ),
      ),
      body: Container(
        child: _auth.currentUser == null
            ? Spinner()
            : ListView(
                children: List<Widget>.from([]) +
                    storyProvider.storyList
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      return StoryCard(
                        storyDetails: entry.value,
                        enableDelete: index > 0,
                      );
                    }).toList(),
              ),
      ),
    );
  }
}
