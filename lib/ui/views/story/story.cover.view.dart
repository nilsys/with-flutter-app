import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:with_app/core/view_models/story.vm.dart';

class StoryCover extends StatefulWidget {
  final ExpandedView expandedView = new ExpandedView();

  @override
  ExpandedView createState() => expandedView;
}

class ExpandedView extends State<StoryCover>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  final StoryVM storyProvider = locator<StoryVM>();
  bool isTaped = false;
  static const coverHeight = 185.0;
  static const gutter = 16.0;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutQuart,
        reverseCurve: Curves.easeInQuart,
      ),
    )..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
  }

  void tappedEvent() {
    if (!isTaped) {
      controller.forward();
      isTaped = !isTaped;
    } else {
      controller.reverse();
      isTaped = !isTaped;
    }
  }

  void collapse() {
    controller.reverse();
    isTaped = false;
  }

  void expand() {
    controller.forward();
    isTaped = true;
  }

  @swidget
  Widget _collpasedTopSction() {
    return Container(
      key: ValueKey(1),
      width: MediaQuery.of(context).size.width - 64.0,
      child: Row(
        children: [
          storyProvider.story.cover != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    storyProvider.story.cover,
                    fit: BoxFit.cover,
                    width: 52.0,
                    height: 52.0,
                  ),
                )
              : SizedBox(),
          Container(
            width:
                MediaQuery.of(context).size.width - 52.0 - 64.0 - (gutter * 2),
            margin: EdgeInsets.only(left: gutter),
            child: Text(
              storyProvider.story.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  @swidget
  Widget _expandedTopSction() {
    return Container(
      key: ValueKey(2),
      width: MediaQuery.of(context).size.width - 64.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              splashColor: Colors.black.withAlpha(70),
              radius: 45,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.more_horiz),
              ),
              onTap: () {},
            ),
          ),
          SizedBox(
            width: gutter,
          ),
          Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 30.0,
              child: OutlineButton(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).accentColor,
                ),
                splashColor: Colors.black.withAlpha(70),
                child: Text('Folloow'),
                onPressed: () {},
                textColor: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('storyProvider.story: ${storyProvider.story.cover}');
    return new GestureDetector(
      child: new Material(
        elevation: 50.01,
        color: Colors.transparent,
        child: ClipRRect(
          // borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0)),
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(34.0 * animation.value)),
          child: Container(
            height: storyProvider.collpasedHeight +
                animation.value * (coverHeight + 240),
            decoration: BoxDecoration(
              color: Color.fromRGBO(232, 232, 232, 1),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [Colors.blue, Colors.blueAccent],
              //   tileMode:
              //       TileMode.repeated, // repeats the gradient over the canvas
              // ),
              // borderRadius: new BorderRadius.vertical(
              //   bottom: new Radius.circular(animation.value / 10),
              // ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                OverflowBox(
                  alignment: Alignment.topLeft,
                  minHeight: 0.0,
                  maxHeight: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: storyProvider.collpasedHeight - 10.0,
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                splashColor: Colors.black.withAlpha(70),
                                radius: 45,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(Icons.arrow_back),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            AnimatedSwitcher(
                              child: isTaped == true
                                  ? _expandedTopSction()
                                  : _collpasedTopSction(),
                              duration: const Duration(milliseconds: 600),
                              switchInCurve: Curves.easeOutQuart,
                              switchOutCurve: Curves.easeInQuart,
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) =>
                                      FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  child: child,
                                  scale: animation,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      storyProvider.story.cover != null
                          ? Image.network(
                              storyProvider.story.cover,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: coverHeight,
                            )
                          : SizedBox(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(gutter, 14.0, gutter, 0.0),
                        child: Text(
                          storyProvider.story.title,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(gutter, 6.0, gutter, 0.0),
                        child: Text(
                          storyProvider.story.description,
                          // style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8.0 + (4.0 * animation.value),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 750),
                        curve: Curves.easeOutQuart,
                        width: 26 + (50.0 * animation.value),
                        height: 4.0,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        tappedEvent();
      },
      onPanUpdate: (details) {
        if (details.delta.dy > 0) {
          expand();
        } else if (details.delta.dy < 0) {
          collapse();
        }
      },
    );
  }
}
