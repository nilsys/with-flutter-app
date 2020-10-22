import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/ui/views/home/home.view.dart';
import 'package:with_app/ui/shared/all.dart';

import 'social_login.view.dart';

class AuthView extends StatefulWidget {
  static const String route = 'auth';

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<AuthView> {
  final TextEditingController emailController = TextEditingController();
  bool _emailIsValid = false;
  final _auth = FirebaseAuth.instance;
  bool _working = false;
  final UserVM _userService = locator<UserVM>();

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushNamed(this.context, HomeView.route);
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget email = CustomTextInput(
      controller: emailController,
      key: Key('email'),
      deny: RegExp(r"\s+"),
      onChange: (value) {
        bool isValid = EmailValidator.validate(value.trim());
        setState(() {
          _emailIsValid = isValid;
        });
      },
      validator: (value) {
        return EmailValidator.validate(value.trim());
      },
      placeHolder: 'Email',
    );

    void _sendEmailLink() async {
      try {
        await _auth.sendSignInLinkToEmail(
          email: emailController.value.text,
          actionCodeSettings: ActionCodeSettings(
            url:
                'https://withapp.page.link/email-link-signin?email=${emailController.value.text}',
            handleCodeInApp: true,
            androidPackageName: 'io.withapp.android',
            androidMinimumVersion: '21',
            androidInstallApp: true,
            iOSBundleId: 'io.withapp.ios',
          ),
        );
      } on FirebaseAuthException catch (err) {
        print(err);
      } catch (err) {
        print(err);
      }
    }

    final Widget submit = SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: _emailIsValid == true ? _sendEmailLink : null,
        child: Text('Send Link'),
      ),
    );

    final Widget facebook = SocialLogin(
      network: 'Facebook',
      isWorking: (isWorking) {
        setState(() {
          _working = isWorking;
        });
      },
    );

    final Widget google = SocialLogin(
      network: 'Google',
      isWorking: (isWorking) {
        setState(() {
          _working = isWorking;
        });
      },
    );

    Widget working = _working ? Spinner() : SizedBox();

    if (_userService.emailLinkExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Toaster(
          title: 'Login Fail',
          icon: Icon(Icons.error),
          content: Text('Email Link has expired or has already been used'),
        )..show(context);
      });
      _userService.emailLinkExpired = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              email,
              VerticalSpacer(),
              submit,
              VerticalSpacer(),
              VerticalSpacer(),
              facebook,
              VerticalSpacer(),
              google,
              VerticalSpacer(),
              working,
            ],
          ),
        ),
      ),
    );
  }
}
