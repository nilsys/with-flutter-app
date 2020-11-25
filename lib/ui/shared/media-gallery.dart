import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:with_app/core/view_models/camera.vm.dart';
import 'package:with_app/core/view_models/layout.vm.dart';

import 'spinner.dart';

class MediaGallery extends StatefulWidget {
  final List<String> media;
  final Widget right;
  final Function rightAction;
  final Widget left;
  final Function leftAction;
  final Function onRemoveImg;

  MediaGallery({
    @required this.media,
    this.right,
    this.rightAction,
    this.left,
    this.leftAction,
    this.onRemoveImg,
  });

  @override
  _MediaGalleryState createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  final LayoutVM layoutProvider = locator<LayoutVM>();

  final CameraVM cameraProvider = locator<CameraVM>();

  final CarouselController _controller = CarouselController();

  Timer _timer;

  int carouselIndex = 0;

  @override
  void didChangeDependencies() {
    if (widget.onRemoveImg != null) {
      Provider.of<CameraVM>(context, listen: true);
      _timer =
          Timer(Duration(milliseconds: widget.media.length > 1 ? 1000 : 0), () {
        setState(() {
          carouselIndex = max(widget.media.length - 1, 0);
        });
        _animateToPage();
      });
      if (cameraProvider.filePath.length == 0) {
        _timer?.cancel();
      } else {
        _animateToPage();
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _animateToPage() {
    _controller.animateToPage(
      carouselIndex,
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    @swidget
    List<Widget> mediaIndicator() {
      List<String> images = widget.media;

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
              milliseconds:
                  images.length < 4 || images.length - carouselIndex < 3
                      ? 0
                      : 250),
          opacity:
              images.length < 4 || images.length - carouselIndex < 3 ? 0 : 1,
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 64,
            child: TextButton(
              onPressed: widget.leftAction,
              child: Transform.translate(
                offset: Offset(5, 0),
                child: widget.left != null ? widget.left : SizedBox(),
              ),
            ),
          ),
          Container(
            // Media Indicator
            child: widget.media.length > 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: mediaIndicator(),
                  )
                : SizedBox(),
          ),
          Container(
            width: 64,
            child: TextButton(
              onPressed: widget.rightAction,
              child: Transform.translate(
                offset: Offset(5, 0),
                child: widget.right != null ? widget.right : SizedBox(),
              ),
            ),
          ),
        ],
      );
    }

    if (widget.media.length > 0) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(layoutProvider.gutter / 2),
            child: CarouselSlider.builder(
                carouselController: _controller,
                itemCount: widget.media.length,
                itemBuilder: (BuildContext context, int itemIndex) => Container(
                      key: ValueKey(widget.media[itemIndex]),
                      color: Colors.black,
                      child: Stack(
                        children: [
                          widget.media[itemIndex].startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: widget.media[itemIndex],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  placeholder: (context, url) => Spinner(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : Image.file(
                                  File(widget.media[itemIndex]),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),
                          widget.onRemoveImg != null
                              ? Positioned(
                                  right: layoutProvider.gutter / 2,
                                  top: layoutProvider.gutter / 2,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      splashColor: Colors.white.withAlpha(70),
                                      radius: 45,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Icon(
                                          Icons.close,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        // reset carouselIndex
                                        setState(() {
                                          if (carouselIndex == 0) {
                                            if (widget.media.length > 1) {
                                              carouselIndex = 1;
                                            }
                                          } else {
                                            carouselIndex = carouselIndex - 1;
                                          }
                                        });
                                        _animateToPage();
                                        _timer = Timer(
                                            Duration(
                                                milliseconds:
                                                    widget.media.length > 1
                                                        ? 1000
                                                        : 0), () {
                                          widget.onRemoveImg(
                                              widget.media[itemIndex]);
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.width * 1.12,
                  aspectRatio: 1 / 1.12,
                  viewportFraction: 1,
                  initialPage: widget.onRemoveImg != null ? carouselIndex : 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  // autoPlay: false,
                  // autoPlayInterval: Duration(seconds: 3),
                  // autoPlayAnimationDuration: Duration(milliseconds: 800),
                  // autoPlayCurve: Curves.fastOutSlowIn,
                  // enlargeCenterPage: true,
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    setState(() {
                      carouselIndex = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                )),
          ),
          renderBottom(),
        ],
      );
    }
    return SizedBox();
  }
}
