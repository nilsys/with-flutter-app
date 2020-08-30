import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:with_app/ui/style_guide.dart';
import 'package:with_app/core/services/firebase_handler.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    FirebaseHandler fbHandler = FirebaseHandler();
    setDeeplinkClickHandler(fbHandler);
    setDeeplinkBGHandler(fbHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/addStory');
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: Container(
        padding: StyleGuide.pageBleed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'images/logo_light.svg',
              semanticsLabel: 'With Logo',
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (!EmailValidator.validate(value.trim())) {
                        return 'Please enter a valid email addresss';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    onSaved: (value) {
                      _userEmail = value.trim();
                    },
                  ),
                  // TextFormField(
                  //   key: ValueKey('password'),
                  //   validator: (value) {
                  //     if (value.isEmpty || value.length < 7) {
                  //       return 'Password must be at least 7 characters long';
                  //     }
                  //     return null;
                  //   },
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //     labelText: 'Password',
                  //   ),
                  //   onSaved: (value) {
                  //     _userPassword = value.trim();
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setDeeplinkClickHandler(FirebaseHandler fbHandler) {
    fbHandler.getDynamiClikData().then((link) {
      if (link != null) {
        print('Deep link found $link ******');
        Navigator.pushNamed(context, '/dashboard');
      }
    }, onError: (err) {
      print('Error $err');
    });
  }

  setDeeplinkBGHandler(FirebaseHandler fbHandler) {
    fbHandler.getDynamiBGData().then((boolValue) {
      // Take action, you can also put logic to transit to another screen
      if (boolValue) {
        print('Deep link found ******');
      }
    }, onError: (err) {
      print('Error $err');
    });
  }
}
