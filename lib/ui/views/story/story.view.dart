import 'package:flutter/material.dart';

import 'sub_views/story_footer.view.dart';
import 'sub_views/story_settings.view.dart/story_settings.view.dart';
import 'sub_views/time_line.view.dart/time_line.view.dart';

class StoryView extends StatefulWidget {
  static const String route = 'story';
  final String id;

  StoryView({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Timeline(),
                StorySettings(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: StoryFooter(
        onChange: (pageIndex) {
          _pageController.animateToPage(
            pageIndex,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          );
        },
      ),
    );
  }
}
