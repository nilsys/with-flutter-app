import 'package:flutter/material.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/home/home.view.dart';

class StorySettings extends StatefulWidget {
  @override
  _StorySettingsState createState() => _StorySettingsState();
}

class _StorySettingsState extends State<StorySettings> {
  ScrollControl scrollController = ScrollControl();

  @override
  void initState() {
    super.initState();
    scrollController.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(this.context).unfocus();
      },
      child: SingleChildScrollView(
        controller: scrollController.controller,
        child: Column(
          children: [
            Text('StorySettings View'),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(this.context, HomeView.route);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
