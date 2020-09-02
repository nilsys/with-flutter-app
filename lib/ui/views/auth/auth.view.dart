import 'package:flutter/material.dart';
import 'auth_footer.dart';
import 'signup.dart';
import 'login.dart';

class AuthView extends StatefulWidget {
  static const String route = '/auth';

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withRed(150)
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/addStory');
          //   },
          //   child: Icon(Icons.add),
          // ),
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    Login(),
                    Signup(),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: AuthFooter(
            onChange: (pageIndex) {
              _pageController.animateToPage(
                pageIndex,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
              );
            },
          ),
        )
      ],
    );
  }
}
