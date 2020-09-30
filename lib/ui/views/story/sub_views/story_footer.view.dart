import 'package:flutter/material.dart';
import 'package:with_app/with_icons.dart';

class StoryFooter extends StatefulWidget {
  final Function onChange;

  StoryFooter({@required this.onChange});

  @override
  _StoryFooterState createState() => _StoryFooterState();
}

class _StoryFooterState extends State<StoryFooter> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onChange(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black.withAlpha(25),
            Colors.black.withAlpha(85),
          ],
        ),
        border: Border(
          top: BorderSide(width: 1, color: Colors.black.withAlpha(30)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.white.withAlpha(150),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: _onItemTapped,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                With.fairy_wand,
                size: 20.0,
              ),
              title: Text('Timeline'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                With.power_settings_new,
                size: 22.0,
              ),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
