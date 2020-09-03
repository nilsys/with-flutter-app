import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_app/ui/shared/text_input.dart';
import 'package:with_app/ui/shared/toaster.dart';
import 'package:with_app/ui/views/home.view.dart';
import 'package:with_app/ui/shared/spinner.dart';
import 'auth_hero.view.dart';
import 'vertical_spacer.view.dart';

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
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
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
          // titleText: Text("Oops..."),
          icon: Icon(Icons.error),
          content: Text(err.message),
        )..show(context);
      }
    }

    void scrollToBottom() {
      Timer(Duration(milliseconds: 200), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            curve: Curves.linear, duration: Duration(milliseconds: 500));
      });
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
      iconData: Icons.alternate_email_outlined,
      onTap: scrollToBottom,
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
      iconData: Icons.lock_outlined,
    );

    final Widget submit = SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: _emailIsValid && _passwordIsValid ? _tryLogin : null,
        child: Text('LOGIN'),
        // color: Theme.of(context).accentColor,
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
                  // titleText: Text("Oops..."),
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

    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).requestFocus(new FocusNode());
        FocusScope.of(this.context).unfocus();
      },
      child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            VerticalSpacer(),
            submit,
            VerticalSpacer(),
            VerticalSpacer(),
            forgot,
            VerticalSpacer(),
            VerticalSpacer(),
            working,
          ],
        ),
      ),
    );
  }
}