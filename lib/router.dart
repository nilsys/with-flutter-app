import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:with_app/ui/views/new-post/new-post.view.dart';
import 'ui/views/full-screen-media/full_screen_media.view.dart';
import 'ui/views/home/home.view.dart';
// import './views/auth.view.dart';
// import 'ui/views/auth/auth.view.dart';
import 'ui/views/auth/auth.view.dart';
import 'ui/views/story/story.view.dart';
import 'ui/views/camera/camera2.view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    List splitRoute = settings.name.split('/');
    List<String> params = List();
    Map args = settings.arguments;
    final String name = splitRoute[0];
    for (int i = 1; i < splitRoute.length; i++) {
      params.add(splitRoute[i]);
    }
    switch (name) {
      case AuthView.route:
        return MaterialPageRoute(
          builder: (_) => AuthView(),
        );
      case HomeView.route:
        return MaterialPageRoute(
          builder: (_) => HomeView(),
        );
      case StoryView.route:
        return MaterialPageRoute(
          builder: (_) => StoryView(id: params[0]),
        );
      case CameraView.route:
        return MaterialPageRoute(
          builder: (_) => CameraView(),
        );
      case FullScreenMedia.route:
        return MaterialPageRoute(
          builder: (_) => FullScreenMedia(src: params),
        );
      case NewPostView.route:
        return MaterialPageRoute(
          builder: (_) => NewPostView(
            step: args['step'],
            postId: args['postId'],
            postIndex: args['postIndex'],
          ),
        );
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
