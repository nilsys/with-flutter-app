import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './views/home.view.dart';
// import './views/auth.view.dart';
import 'views/auth/auth.view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthView.route:
        return MaterialPageRoute(builder: (_) => AuthView());
      case HomeView.route:
        return MaterialPageRoute(builder: (_) => HomeView());
      // case '/addProduct' :
      //   return MaterialPageRoute(
      //     builder: (_)=> AddProduct()
      //   ) ;
      // case '/productDetails' :
      //   return MaterialPageRoute(
      //       builder: (_)=> ProductDetails()
      //   ) ;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
