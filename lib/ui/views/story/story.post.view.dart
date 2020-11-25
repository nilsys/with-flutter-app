import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:strings/strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/view_models/layout.vm.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/new-post/new-post.view.dart';

final NavigationService navService = NavigationService();

class StoryPost extends StatefulWidget {
  final Post post;
  final int postIndex;

  StoryPost({
    @required this.post,
    @required this.postIndex,
  });

  @override
  _StoryPostState createState() => _StoryPostState();
}

class _StoryPostState extends State<StoryPost> {
  static const verticalSpace = 30.0;
  int carouselIndex = 0;
  bool _seeMore = false;
  CarouselController carouselController = CarouselController();

  final StoryVM storyProvider = locator<StoryVM>();

  final LayoutVM layoutProvider = locator<LayoutVM>();

  @swidget
  Widget postTopSection() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(camelize(timeago.format(widget.post.timestamp)),
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: storyProvider.firstUnread >= widget.postIndex
                        ? Theme.of(context).indicatorColor
                        : Theme.of(context).textTheme.subtitle2.color,
                  )),
          IconButton(
            icon: Icon(Icons.more_horiz),
            color: Colors.black.withAlpha(100),
            splashRadius: 20.0,
            onPressed: showMenu,
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 4.0,
                ),
                Text('Share', style: Theme.of(context).textTheme.subtitle2),
                Transform.translate(
                  offset: Offset(0.0, 0.0),
                  child: Icon(
                    Icons.arrow_right_alt_sharp,
                    color: Colors.black.withAlpha(100),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  @swidget
  Widget renderMedia() {
    List<String> images = widget.post.media;
    if (images[0] != null) {
      // return Container(
      //   margin: EdgeInsets.only(top: gutter),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(gutter / 2),
      //     child: Image.network(
      //       widget.post.media.images[0],
      //       fit: BoxFit.cover,
      //       width: MediaQuery.of(context).size.width,
      //       height: MediaQuery.of(context).size.width * 1.12,
      //     ),
      //   ),
      // );
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: layoutProvider.gutter),
            child: MediaGallery(
              media: images,
              left: SizedBox(width: 64.0),
              right: Container(
                margin: EdgeInsets.only(right: layoutProvider.gutter / 2),
                child: Container(
                  width: 64.0,
                  child: TextButton(
                    onPressed: () {},
                    child: Transform.translate(
                      offset: Offset(5, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.forum_outlined),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  @swidget
  List<Widget> mediaIndicator() {
    List<String> images = widget.post.media;

    final List<Widget> list = [
      Transform.translate(
        offset: Offset(8.0, 0),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: carouselIndex < 3 ? 0 : 250),
          opacity: carouselIndex < 3 ? 0 : 1,
          child: Icon(
            Icons.arrow_left_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
      )
    ];

    for (int i = 0; i < min(3, images.length); i++) {
      list.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0),
        child: Icon(Icons.fiber_manual_record,
            size: 10,
            color: i == carouselIndex % 3
                ? Theme.of(context).accentColor
                : (images.length > 3) &&
                        (i >= images.length % 3) &&
                        (images.length - carouselIndex < 3)
                    ? Colors.transparent
                    : Colors.black),
      ));
    }

    list.add(Transform.translate(
      offset: Offset(-8.0, 0),
      child: AnimatedOpacity(
        duration: Duration(
            milliseconds: images.length < 4 || images.length - carouselIndex < 3
                ? 0
                : 250),
        opacity: images.length < 4 || images.length - carouselIndex < 3 ? 0 : 1,
        child: Icon(
          Icons.arrow_right_rounded,
          size: 30,
          color: Colors.black,
        ),
      ),
    ));

    return list.toList();
  }

  @swidget
  Widget postTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        capitalize(widget.post.title),
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: verticalSpace),
      margin: EdgeInsets.only(
        // top: 6.0 + (widget.index > 0 ? 0 : storyProvider.collpasedHeight),
        top: 6.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: layoutProvider.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                postTopSection(),
                widget.post.text.length > 0
                    ? LayoutBuilder(
                        builder: (context, size) {
                          final span = TextSpan(
                            text: widget.post.text,
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
                            return ExpandableNotifier(
                              child: ScrollOnExpand(
                                scrollOnExpand: true,
                                scrollOnCollapse: false,
                                child: Expandable(
                                  // <-- Driven by ExpandableController from ExpandableNotifier
                                  collapsed: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      postTitle(),
                                      Text(
                                        widget.post.text,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                      ExpandableButton(
                                        // <-- Expands when tapped on the cover photo
                                        child: Text('More..',
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                            // textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ],
                                  ),
                                  expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        postTitle(),
                                        Text(
                                          widget.post.text,
                                        ),
                                        ExpandableButton(
                                          // <-- Collapses when tapped on
                                          child: Text('Less',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline
                                              // textAlign: TextAlign.center,
                                              ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                postTitle(),
                                Text(widget.post.text),
                              ],
                            );
                          }
                        },
                      )
                    : postTitle(),
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
            padding: EdgeInsets.all(layoutProvider.gutter),
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
                  onPressed: () {
                    storyProvider.scrollToIndex = widget.postIndex;
                    navService.goBack();
                    navService.pushNamed(
                      '${NewPostView.route}/1/${widget.post.id}',
                      args: {'postId': widget.post.id},
                    );
                  },
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
