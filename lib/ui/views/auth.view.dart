import 'package:flutter/material.dart';
import 'package:with_app/core/models/story.model.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/addStory');
      //   },
      //   child: Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: Center(child: Text('Auth')),
      ),
      body: Container(
        child: Text(
          'auth screen',
          key: Key('auth_screen'),
        ),
      ),
    );
  }
}
