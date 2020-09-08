import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_app/ui/views/home/home.view.dart';
import 'package:with_app/ui/shared/all.dart';
import '../auth_hero.view.dart';

import 'social_login.view.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };
  bool _emailIsValid = false;
  bool _passwordIsValid = false;
  bool _working = false;
  ScrollControl scrollController = ScrollControl();

  @override
  void initState() {
    super.initState();
    scrollController.init();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushNamed(this.context, HomeView.route);
      }
    });
  }

  @override
  void dispose() {
    controllers['email'].dispose();
    controllers['password'].dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _tryLogin() async {
      FocusScope.of(this.context).unfocus();
      try {
        setState(() {
          _working = true;
        });
        await _auth.signInWithEmailAndPassword(
          email: controllers['email'].value.text,
          password: controllers['password'].value.text,
        );
      } on PlatformException catch (err) {
        print(err);
      } catch (err) {
        setState(() {
          _working = false;
        });
        Toaster(
          icon: Icon(Icons.error),
          content: Text(err.message),
        )..show(context);
      }
    }

    final Widget email = CustomTextInput(
      controller: controllers['email'],
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
      onTap: scrollController.scrollToBottom,
    );

    final Widget password = CustomTextInput(
      controller: controllers['password'],
      key: Key('password'),
      deny: RegExp(r"\s+"),
      obscureText: true,
      onChange: (value) {
        bool isValid = value.length >= 7;
        setState(() {
          _passwordIsValid = isValid;
        });
      },
      validator: (value) {
        return value.length >= 7;
      },
      placeHolder: 'Password',
    );

    final Widget submit = SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: _emailIsValid && _passwordIsValid ? _tryLogin : null,
        child: Text('LOGIN'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        textColor: Colors.black,
      ),
    );

    final Widget forgot = FlatButton(
      onPressed: _emailIsValid
          ? () async {
              FocusScope.of(this.context).unfocus();
              scrollController.scrollToBottom();
              setState(() {
                _working = true;
              });
              try {
                await _auth.sendPasswordResetEmail(
                  email: controllers['email'].value.text,
                );
              } on PlatformException catch (err) {
                print(err);
              } catch (err) {
                setState(() {
                  _working = false;
                });
                Toaster(
                  icon: Icon(Icons.error),
                  content: Text(err.message),
                )..show(context);
                return;
              }
              setState(() {
                _working = false;
              });
              Toaster(
                title: 'Forgot Password',
                icon: Icon(Icons.email_outlined),
                content: Text(
                    'No worries, we sent you an email with a link to reset your password'),
              )..show(context);
            }
          : () {
              Toaster(
                title: 'Forgot Password',
                icon: Icon(Icons.error),
                content: Text('Please enter your email first'),
              )..show(context);
            },
      child: Text(
        'Forgot Password ?',
        style: TextStyle(
          color: Theme.of(context)
              .textTheme
              .bodyText1
              .color
              .withAlpha(_emailIsValid ? 255 : 120),
        ),
      ),
    );

    Widget working = _working ? Spinner() : SizedBox();

    final Widget facebook = SocialLogin(
      network: 'Facebook',
      isWorking: (isWorking) {
        setState(() {
          _working = isWorking;
        });
        scrollController.scrollToBottom();
      },
    );

    final Widget google = SocialLogin(
      network: 'Google',
      isWorking: (isWorking) {
        setState(() {
          _working = isWorking;
        });
        scrollController.scrollToBottom();
      },
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(this.context).unfocus();
      },
      child: SingleChildScrollView(
        controller: scrollController.controller,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          children: [
            AuthHero(
              text: 'Login',
            ),
            VerticalSpacer(),
            VerticalSpacer(),
            email,
            VerticalSpacer(),
            password,
            VerticalSpacer(),
            submit,
            VerticalSpacer(),
            VerticalSpacer(),
            facebook,
            VerticalSpacer(),
            google,
            VerticalSpacer(),
            VerticalSpacer(),
            forgot,
            VerticalSpacer(),
            working,
            VerticalSpacer(),
            VerticalSpacer(),
          ],
        ),
      ),
    );
  }
}
