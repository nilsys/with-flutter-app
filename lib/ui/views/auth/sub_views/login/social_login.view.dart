import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/models/user_stories.model.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/with_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLogin extends StatelessWidget {
  // available network values are 'facebook' | 'google'
  final String network;

  // callback for notifiying the parent about working status
  final Function isWorking;

  SocialLogin({
    @required this.network,
    @required this.isWorking,
  });

  final _auth = FirebaseAuth.instance;
  final UserVM _userVM = UserVM();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  final FacebookLogin facebookLogin = new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    void _tryFacebookLogin() async {
      FocusScope.of(context).unfocus();
      try {
        isWorking(true);
        final FacebookLoginResult result = await facebookLogin.logIn(['email']);
        switch (result.status) {
          case FacebookLoginStatus.loggedIn:
            final FacebookAuthCredential facebookAuthCredential =
                FacebookAuthProvider.credential(result.accessToken.token);
            final UserCredential credentials =
                await _auth.signInWithCredential(facebookAuthCredential);
            _userVM.updateUser(
                UserModel(
                  displayName: credentials.additionalUserInfo.username,
                  email: credentials.user.email,
                  profileImage: credentials.user.photoURL,
                  stories: UserStories(),
                ),
                credentials.user.uid);
            break;
          case FacebookLoginStatus.cancelledByUser:
            print('facebook login canceled by user');
            Toaster(
              title: 'Facebook Login',
              icon: Icon(Icons.error),
              content: Text('Facebook login canceled'),
            )..show(context);
            isWorking(false);
            break;
          case FacebookLoginStatus.error:
            print(result.errorMessage);
            Toaster(
              title: 'Facebook Login',
              icon: Icon(Icons.error),
              content: Text(result.errorMessage),
            )..show(context);
            isWorking(false);
            break;
        }
      } on PlatformException catch (err) {
        print(err);
      } catch (err) {
        print(err);
        isWorking(false);
        Toaster(
          title: 'Facebook Login',
          icon: Icon(Icons.error),
          content: Text('Oops! somthing went wrong...'),
        )..show(context);
      }
    }

    void _tryGoogleLogin() async {
      FocusScope.of(context).unfocus();
      try {
        isWorking(true);
        final GoogleSignInAccount googleSignInAccount =
            await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential credentials =
            await _auth.signInWithCredential(credential);
        print(credentials);
        _userVM.updateUser(
            UserModel(
              displayName: credentials.additionalUserInfo.profile['name'],
              email: credentials.user.email,
              profileImage: credentials.user.photoURL,
              stories: UserStories(),
            ),
            credentials.user.uid);
      } on PlatformException catch (err) {
        print(err);
        isWorking(false);
      } catch (err) {
        print(err);
        isWorking(false);
        Toaster(
          title: 'Google Login',
          icon: Icon(Icons.error),
          content: Text('Oops! somthing went wrong...'),
        )..show(context);
      }
    }

    Function _getLoginFunction() {
      switch (network) {
        case 'Facebook':
          return _tryFacebookLogin;
        case 'Google':
          return _tryGoogleLogin;
        default:
          return null;
      }
    }

    IconData _getNetworkIcon() {
      switch (network) {
        case 'Facebook':
          return With.facebook;
        case 'Google':
          return With.google;
        default:
          return null;
      }
    }

    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        onPressed: _getLoginFunction(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 25,
              child: Icon(_getNetworkIcon()),
            ),
            Center(
              child: Text('Continue with $network'),
            ),
            SizedBox(
              width: 25,
            ),
          ],
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        borderSide: BorderSide(
          color: Colors.white.withAlpha(100),
        ),
      ),
    );
  }
}
