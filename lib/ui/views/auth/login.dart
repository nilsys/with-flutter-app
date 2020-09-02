import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_app/ui/views/home.view.dart';
import 'auth_hero.dart';
import 'text_input.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllers['email'].dispose();
    controllers['password'].dispose();
    super.dispose();
  }

  Widget _verticalSpacer = SizedBox(
    height: 12,
  );

  @override
  Widget build(BuildContext context) {
    void _tryLogin() async {
      FocusScope.of(this.context).unfocus();
      _auth.authStateChanges().listen((user) {
        if (user != null) {
          Navigator.pushNamed(this.context, HomeView.route);
        }
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: controllers['email'].value.text,
          password: controllers['password'].value.text,
        );
      } on PlatformException catch (err) {
        print(err);
      } catch (err) {
        Flushbar(
          // titleText: Text("Oops..."),
          icon: Icon(Icons.error),
          messageText: Text(err.message),
          duration: Duration(seconds: 6),
          margin: EdgeInsets.fromLTRB(15, 0, 15, 84),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          borderRadius: 10,
          isDismissible: true,
          forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
          reverseAnimationCurve: Curves.easeOutCubic,

          barBlur: 10,
          backgroundColor: Colors.black.withAlpha(80),
        )..show(context);
      }
    }

    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).requestFocus(new FocusNode());
        FocusScope.of(this.context).unfocus();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AuthHero(
              text: 'Login',
            ),
            _verticalSpacer,
            _verticalSpacer,
            CustomTextInput(
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
            ),
            _verticalSpacer,
            CustomTextInput(
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
            ),
            _verticalSpacer,
            _verticalSpacer,
            SizedBox(
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
            )
          ],
        ),
      ),
    );
  }
}
