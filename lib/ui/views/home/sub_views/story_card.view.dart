import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/views/story/story.view.dart';

class StoryCard extends StatelessWidget {
  final Story storyDetails;
  final bool enableDelete;

  StoryCard({@required this.storyDetails, this.enableDelete = true});

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryVM>(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '${StoryView.route}/${storyDetails.id}');
      },
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
                    SizedBox(
                      height: 22.0,
                    ),
                    Row(
                      children: [
                        RaisedButton(
                          onPressed: () {
                            storyProvider.duplicateStory(storyDetails);
                          },
                          child: Text('Duplicate'),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.red,
                          onPressed: enableDelete
                              ? () {
                                  storyProvider.deleteStory(storyDetails.id);
                                }
                              : null,
                          child: Text('Delete'),
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
