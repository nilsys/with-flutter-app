import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:with_app/ui/views/story/story.view.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:with_app/core/models/user.model.dart';
// import 'package:with_app/locator.dart';

final NavigationService navService = NavigationService();

class DynamicLinkService {
  // final _auth = FirebaseAuth.instance;
  // final UserService _userService = locator<UserService>();

  Future handleDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data, context);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(dynamicLink, context);
    }, onError: (OnLinkErrorException e) async {
      print('Dynamic link faild');
      print(e.message);
    });
  }

  void _handleDeepLink(
      PendingDynamicLinkData data, BuildContext context) async {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      switch (deepLink.path) {
        case '/go-to-story':
          final String storyId = deepLink.queryParameters['id'];
          if (storyId != null) {
            navService.pushNamed('${StoryView.route}/$storyId');
          }
      }
      // if (deepLink.path == '/__/auth/action') {
      //   final String email =
      //       deepLink.queryParameters['continueUrl'].split('=')[1];
      //   try {
      //     final UserCredential credentials = await _auth.signInWithEmailLink(
      //       email: email,
      //       emailLink: deepLink.toString(),
      //     );
      //     print('credentials $credentials');
      //     await _userService.setUser(
      //         UserModel(
      //           email: credentials.user.email,
      //           displayName: credentials.user.email.split('@')[0],
      //         ),
      //         credentials.user.uid);
      //   } on FirebaseAuthException catch (err) {
      //     print(err);
      //   } on PlatformException catch (err) {
      //     print(err);
      //   } catch (err) {
      //     print(err);
      //   }
      // }
    }
  }
}
