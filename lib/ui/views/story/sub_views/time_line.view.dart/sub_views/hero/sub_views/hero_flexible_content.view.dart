import 'package:flutter/material.dart';

class HeroFlexibleContent extends StatefulWidget {
  final double height;

  HeroFlexibleContent({
    @required this.height,
  });

  @override
  _HeroFlexibleContentState createState() => _HeroFlexibleContentState();
}

class _HeroFlexibleContentState extends State<HeroFlexibleContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 40.0),
          height: widget.height + 54,
          color: Colors.red,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                // title: Transform.translate(
                //   offset: Offset(0.0, -30.0),
                //   child: Text('title'),
                // ),
                backgroundColor: Colors.blue,
                titleSpacing: 0.0,
                // collapsedHeight: 1.0,
                expandedHeight: widget.height - 10.0,
                toolbarHeight: 0.0,
                elevation: 0.0,
                // pinned: true,
                floating: true,
                leading: null,
                forceElevated: false,
                automaticallyImplyLeading: false,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipRRect(
                      child: OverflowBox(
                        alignment: Alignment.topLeft,
                        minHeight: 0.0,
                        maxHeight: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 17.0,
                            ),
                            Text('top'),
                            Text('top'),
                            Text('top'),
                            Text('top'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 22.0,
                          ),
                          Text('Comment $index'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            // width: double.infinity,
            color: Colors.yellow,
            height: 40.0,
            child: Center(
              child: Text('Input box'),
            ),
          ),
        ),
      ],
    );
  }
}
