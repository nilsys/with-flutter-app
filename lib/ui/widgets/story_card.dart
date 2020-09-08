import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';

class StoryCard extends StatelessWidget {
  final Story storyDetails;

  StoryCard({@required this.storyDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (_) => StoryView(story: storyDetails)));
      // },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(16),
            // height: MediaQuery.of(context).size.height * 0.45,
            // width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Title: ',
                          ),
                          Text(
                            storyDetails.title,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Owner ID: ',
                          ),
                          Text(
                            storyDetails.owner,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Followers: ',
                          ),
                          Text(
                            '${storyDetails.followers.length}',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Viewers: ',
                          ),
                          Text(
                            '${storyDetails.viewers.length}',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Views: ',
                          ),
                          Text(
                            '${storyDetails.views}',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Story ID: ',
                        ),
                        Text(
                          storyDetails.id,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
