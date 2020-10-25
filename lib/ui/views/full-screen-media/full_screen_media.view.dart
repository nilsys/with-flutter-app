import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:with_app/ui/shared/all.dart';

class FullScreenMedia extends StatefulWidget {
  static const String route = 'full-screen-media';

  final List<String> src;

  FullScreenMedia({
    @required this.src,
  });

  @override
  _FullScreenMediaState createState() => _FullScreenMediaState();
}

class _FullScreenMediaState extends State<FullScreenMedia> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final pageView = LiquidSwipe(
      // controller: pageController,
      // scrollDirection: Axis.vertical,
      enableLoop: false,
      waveType: WaveType.circularReveal,
      onPageChangeCallback: (int page) {
        setState(() {
          currentPage = page;
        });
      },
      pages: this
          .widget
          .src
          .map(
            (url) => CachedNetworkImage(
              imageUrl: Uri.decodeFull(url),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) => Spinner(),
              errorWidget: (context, url, error) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error,
                      size: 44,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 16.0,
                      ),
                      child: Text('Can\'t find media file'),
                    )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );

    @swidget
    Widget appBar() => SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Back',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
          ),
        );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: pageView,
          ),
          widget.src.length > 1
              ? Transform.translate(
                  offset: Offset(0.0, -10.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedOpacity(
                      opacity: currentPage == 0 ? 0.3 : 0,
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.swap_horiz_rounded,
                        size: 52.0,
                      ),
                    ),
                  ),
                )
              : Container(),
          appBar(),
        ],
      ),
    );
  }
}
