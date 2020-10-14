import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
// import 'package:with_app/ui/views/ModifyStory.dart';
import 'package:provider/provider.dart';

class StoryCard extends StatelessWidget {
  final Story story;

  StoryCard({@required this.story});

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryVM>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Story Details'),
        actions: <Widget>[
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              await storyProvider.removeStory(story.id);
              Navigator.pop(context);
            },
          ),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_)=> ModifyStory(story: story,)));
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            story.title,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic),
          ),
          Text(
            story.owner,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: Colors.orangeAccent),
          )
        ],
      ),
    );
  }
}
