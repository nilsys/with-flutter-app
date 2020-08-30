import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseHandler {
  Future<dynamic> _deepLinkBackground;
  FirebaseAuth _auth;

  FirebaseHandler() {
    _auth = FirebaseAuth.instance;
    initialiseFirebaseOnlink(_deepLinkBackground);
  }

  Future getDynamiClikData() async {
    //Returns the deep linked data
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    print('*****');
    print(data);
    print('*****');
    return data?.link;
  }

  Future getDynamiBGData() {
    //Returns the deep linked data
    return _deepLinkBackground ??
        Future(() {
          return false;
        });
  }

  sendEmail(email) {
    _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: 'https://withapp.page.link/',
        android: {
          'packageName': 'io.withapp.android',
          'installApp': true,
          'minimumVersion': '21'
        },
        // dynamicLinkDomain: 'withapp.page.link',
        handleCodeInApp: true,
        iOS: {
          'bundleId': 'io.withapp.ios',
        },
      ),
    );
  }

  initialiseFirebaseOnlink(_deepLinkBackground) {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        _deepLinkBackground = Future(() {
          return deepLink;
        });
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }
}
