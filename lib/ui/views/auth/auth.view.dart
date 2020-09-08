import 'package:flutter/material.dart';
import 'sub_views/auth_footer.view.dart';
import 'sub_views/signup/signup.view.dart';
import 'sub_views/login/login.view.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                    Signup(),
                    Login(),
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
