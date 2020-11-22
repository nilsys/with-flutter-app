import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:strings/strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/shared/all.dart';

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
  int carouselIndex = 0;
  bool _seeMore = false;
  final StoryVM storyProvider = locator<StoryVM>();
  CarouselController carouselController = CarouselController();

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
    List<String> images = storyProvider.posts[widget.index].media.images;
    if (images[0] != null) {
      // return Container(
      //   margin: EdgeInsets.only(top: gutter),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(gutter / 2),
      //     child: Image.network(
      //       storyProvider.posts[widget.index].media.images[0],
      //       fit: BoxFit.cover,
      //       width: MediaQuery.of(context).size.width,
      //       height: MediaQuery.of(context).size.width * 1.12,
      //     ),
      //   ),
      // );
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: gutter),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(gutter / 2),
              child: CarouselSlider.builder(
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int itemIndex) =>
                      Container(
                        color: Colors.black,
                        child: CachedNetworkImage(
                          imageUrl: images[itemIndex],
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          placeholder: (context, url) => Spinner(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.width * 1.12,
                    aspectRatio: 1 / 1.12,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    // autoPlay: false,
                    // autoPlayInterval: Duration(seconds: 3),
                    // autoPlayAnimationDuration: Duration(milliseconds: 800),
                    // autoPlayCurve: Curves.fastOutSlowIn,
                    // enlargeCenterPage: true,
                    onPageChanged:
                        (int index, CarouselPageChangedReason reason) {
                      setState(() {
                        carouselIndex = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                  )),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  @swidget
  List<Widget> mediaIndicator() {
    List<String> images = storyProvider.posts[widget.index].media.images;

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
  Widget renderBottom() {
    List<String> images = storyProvider.posts[widget.index].media.images;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 64.0,
        ),
        Container(
          // Media Indicator
          child: images.length > 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: mediaIndicator(),
                )
              : SizedBox(),
        ),
        Container(
          width: 64,
          child: TextButton(
            onPressed: () {
              setState(() {
                _seeMore = !_seeMore;
              });
            },
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
      ],
    );
  }

  @swidget
  Widget postTitle() {
    return Text(
      capitalize(storyProvider.posts[widget.index].title),
      style: Theme.of(context).textTheme.headline1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: verticalSpace),
      margin: EdgeInsets.only(top: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                postTopSection(storyProvider.posts[widget.index].timestamp),
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
                            return ExpandableNotifier(
                              // <-- Provides ExpandableController to its children
                              child: ScrollOnExpand(
                                scrollOnExpand: true,
                                scrollOnCollapse: false,
                                child: Expandable(
                                  // <-- Driven by ExpandableController from ExpandableNotifier
                                  collapsed: Column(
                                    children: [
                                      postTitle(),
                                      ExpandableButton(
                                        // <-- Expands when tapped on the cover photo
                                        child: Text(
                                          storyProvider
                                              .posts[widget.index].text,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                  expanded: Column(children: [
                                    postTitle(),
                                    ExpandableButton(
                                      // <-- Collapses when tapped on
                                      child: Text(
                                        storyProvider.posts[widget.index].text,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            );
                            // return Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     _seeMore
                            //         ? Text(
                            //             storyProvider.posts[widget.index].text,
                            //           )
                            //         : Text(
                            //             storyProvider.posts[widget.index].text,
                            //             maxLines: 4,
                            //             overflow: TextOverflow.ellipsis,
                            //             softWrap: false,
                            //           ),
                            //     InkWell(
                            //       borderRadius: BorderRadius.circular(4.0),
                            //       onTap: () {
                            //         setState(() {
                            //           _seeMore = !_seeMore;
                            //         });
                            //       },
                            //       child: Text('More..',
                            //           style:
                            //               Theme.of(context).textTheme.overline
                            //           // textAlign: TextAlign.center,
                            //           ),
                            //     ),
                            //   ],
                            // );
                          } else {
                            return Column(
                              children: [
                                postTitle(),
                                Text(storyProvider.posts[widget.index].text),
                              ],
                            );
                          }
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),
          renderMedia(),
          renderBottom(),
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
