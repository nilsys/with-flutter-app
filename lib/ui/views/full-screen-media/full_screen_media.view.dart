import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

class FullScreenMedia extends StatelessWidget {
  static const String route = 'full-screen-media';

  final String src;

  FullScreenMedia({
    @required this.src,
  });

  @override
  Widget build(BuildContext context) {
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
            child: CachedNetworkImage(
              imageUrl: src,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
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
          ),
          appBar(),
        ],
      ),
    );
  }
}
