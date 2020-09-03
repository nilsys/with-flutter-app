import 'package:flutter/material.dart';
import 'sub_views/auth_footer.view.dart';
import 'sub_views/signup/signup.view.dart';
import 'sub_views/login.view.dart';

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
