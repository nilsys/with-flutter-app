import 'package:flutter/material.dart';
import 'package:with_app/ui/shared/all.dart';
// import 'package:with_app/ui/views/home/home.view.dart';

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
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('SliverAppBar'),
            backgroundColor: Theme.of(context).primaryColorLight,
            expandedHeight: MediaQuery.of(context).size.width * 0.5,
            // collapsedHeight: 80.0,
            pinned: true,
            // flexibleSpace: FlexibleSpaceBar(
            //   background: Image.asset('assets/forest.jpg', fit: BoxFit.cover),
            // ),
          ),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(
              [
                Text('Timeline Posts',
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
