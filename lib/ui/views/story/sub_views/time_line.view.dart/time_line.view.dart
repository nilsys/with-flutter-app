import 'package:flutter/material.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/home/home.view.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
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
            Text('Timeline View', style: Theme.of(context).textTheme.bodyText1),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(this.context, HomeView.route);
              },
              child: Text('Back to Home',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
    );
  }
}
