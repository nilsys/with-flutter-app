import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:strings/strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:with_app/core/view_models/story.vm.dart';

class StoryPost extends StatefulWidget {
  final int index;

  StoryPost({
    @required this.index,
  });

  @override
  _StoryPostState createState() => _StoryPostState();
}

class _StoryPostState extends State<StoryPost> {
  static const verticalSpace = 30.0;
  static const gutter = 16.0;
  bool _seeMore = false;
  final StoryVM storyProvider = locator<StoryVM>();

  @swidget
  Widget newPostsDivider(i) => Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
              margin: EdgeInsets.fromLTRB(
                0,
                verticalSpace / 2,
                0,
                verticalSpace,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(239, 239, 239, 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  '$i Unread Posts',
                  style: TextStyle(color: Theme.of(context).indicatorColor),
                ),
              ),
            ),
          ),
        ],
      );

  @swidget
  Widget postTopSection(timestamp) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(camelize(timeago.format(timestamp)),
              style: Theme.of(context).textTheme.subtitle2),
          IconButton(
            icon: Icon(Icons.more_horiz),
            color: Colors.black.withAlpha(100),
            splashRadius: 20.0,
            onPressed: showMenu,
          )
        ],
      );

  @swidget
  Widget renderMedia() {
    if (storyProvider.posts[widget.index].media.images[0] != null) {
      return Container(
        margin: EdgeInsets.only(top: gutter),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(gutter / 2),
          child: Image.network(
            storyProvider.posts[widget.index].media.images[0],
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: verticalSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                postTopSection(storyProvider.posts[widget.index].timestamp),
                Text(
                  capitalize(storyProvider.posts[widget.index].title),
                  style: Theme.of(context).textTheme.headline1,
                ),
                storyProvider.posts[widget.index].text.length > 0
                    ? LayoutBuilder(
                        builder: (context, size) {
                          final span = TextSpan(
                            text: storyProvider.posts[widget.index].text,
                            style: new TextStyle(color: Colors.grey[600]),
                          );
                          final tp = TextPainter(
                            text: span,
                            maxLines: 4,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            // textDirection: TextDecoration.underline,
                          );
                          tp.layout(maxWidth: size.maxWidth);

                          if (tp.didExceedMaxLines) {
                            // The text has more than three lines.
                            // TODO: display the prompt message
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _seeMore
                                    ? Text(
                                        storyProvider.posts[widget.index].text,
                                      )
                                    : Text(
                                        storyProvider.posts[widget.index].text,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _seeMore = !_seeMore;
                                    });
                                  },
                                  child: Text(
                                    'See more',
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Text(storyProvider.posts[widget.index].text);
                          }
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),
          renderMedia(),
        ],
      ),
    );
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(gutter),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Share',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Edit',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
