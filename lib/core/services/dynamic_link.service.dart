import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/locator.dart';
import 'package:with_app/ui/views/story/story.view.dart';

final NavigationService navService = NavigationService();

class DynamicLinkService {
  final _auth = FirebaseAuth.instance;
  final UserVM _userService = locator<UserVM>();

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
      print('_handleDeepLink | deeplink: $deepLink');
      switch (deepLink.path) {
        case '/go-to-story':
          final String storyId = deepLink.queryParameters['id'];
          if (storyId != null) {
            navService.pushNamed('${StoryView.route}/$storyId');
          }
          break;
        case '/__/auth/action':
          final String email =
              deepLink.queryParameters['continueUrl'].split('=')[1];
          try {
            final UserCredential credentials = await _auth.signInWithEmailLink(
              email: email,
              emailLink: deepLink.toString(),
            );
            print('credentials $credentials');
            List emailSplit = credentials.user.email.split('@');
            await _userService.setUser(
                UserModel(
                  email: credentials.user.email,
                  displayName:
                      '${emailSplit[0]} ${emailSplit[1].split('.')[0]}',
                ),
                credentials.user.uid);
          } on FirebaseAuthException catch (err) {
            print(err);
            _userService.emailLinkExpired = true;
          } on PlatformException catch (err) {
            print(err);
          } catch (err) {
            print(err);
          }
          break;
      }
    }
  }
}
