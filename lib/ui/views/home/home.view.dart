import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/widgets/story_card.dart';
import 'package:with_app/ui/views/auth/auth.view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatefulWidget {
  static const String route = 'home';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Story> stories;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryVM>(context);

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
          onPressed: () {
            _auth.signOut().then((value) => {
                  Navigator.pushNamed(context, AuthView.route),
                });
          },
        ),
      ),
      body: Container(
        child: _auth.currentUser == null
            ? Spinner()
            : StreamBuilder(
                stream: storyProvider.fetchStoriesAsStream(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    stories = snapshot.data.docs
                        .map((doc) => Story.fromMap(doc.data(), doc.id))
                        .toList();
                    return ListView.builder(
                      key: Key('story_list'),
                      itemCount: stories.length,
                      itemBuilder: (buildContext, index) => StoryCard(
                        storyDetails: stories[index],
                        enableDelete: index > 0,
                      ),
                    );
                  } else {
                    return Text(
                      'fetching',
                      key: Key('fetching'),
                    );
                  }
                }),
      ),
    );
  }
}
