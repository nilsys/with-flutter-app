import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story_CRUDModel.dart';
import 'package:with_app/ui/widgets/story_card.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Story> stories;

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryCRUDModel>(context);

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/addStory');
      //   },
      //   child: Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: Center(child: Text('Home')),
      ),
      body: Container(
        child: StreamBuilder(
            stream: storyProvider.fetchStoriesAsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                stories = snapshot.data.docs
                    .map((doc) => Story.fromMap(doc.data(), doc.id))
                    .toList();
                return ListView.builder(
                  itemCount: stories.length,
                  itemBuilder: (buildContext, index) =>
                      StoryCard(storyDetails: stories[index]),
                );
              } else {
                return Text('fetching');
              }
            }),
      ),
    );
  }
}
