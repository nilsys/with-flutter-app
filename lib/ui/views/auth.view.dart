import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:with_app/ui/style_guide.dart';
import 'package:with_app/core/services/firebase_handler.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/models/user_stories.model.dart';
import 'package:with_app/ui/views/home.view.dart';

class AuthView extends StatefulWidget {
  static const String route = '/auth';

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  FirebaseHandler fbHandler;
  String _userEmail = '';
  String _userPassword = '';
  String _userFullName = '';
  UserVM _userVM;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      Navigator.pushNamed(context, HomeView.route);
    }
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushNamed(context, HomeView.route);
      }
    });
    _userVM = new UserVM();
    // fbHandler = FirebaseHandler();
    // setDeeplinkClickHandler(fbHandler);
    // setDeeplinkBGHandler(fbHandler);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    // _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      UserCredential userCredentials =
          await _auth.createUserWithEmailAndPassword(
        email: _userEmail,
        password: _userPassword,
      );
      _userVM.addUser(
          new UserModel(
            id: userCredentials.user.uid,
            email: userCredentials.user.email,
            firstName: _userFullName.split(' ')[0],
            lastName: _userFullName.split(' ')[1],
            stories: new UserStories(
              owner: new List(),
              following: new List(),
              viewing: new List(),
            ),
            leads: new List(),
          ),
          userCredentials.user.uid);
    }
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withRed(150)
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/logo_light.svg',
                  semanticsLabel: 'With Logo',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        key: ValueKey('email'),
                        textAlignVertical: TextAlignVertical(y: 0.1),
                        validator: (value) {
                          if (!EmailValidator.validate(value.trim())) {
                            return 'Please enter a valid email addresss';
                          }
                          return null;
                        },
                        cursorHeight: 20,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          // border: OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.orange, width: 5.0),
                          //   borderRadius:
                          //       BorderRadius.all(Radius.circular(2.0)),
                          // ),
                        ),
                        onSaved: (value) {
                          _userEmail = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        key: ValueKey('password'),
                        textAlignVertical: TextAlignVertical(y: 0.1),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Password must be at least 7 characters long';
                          }
                          return null;
                        },
                        scrollPadding: EdgeInsets.zero,
                        // cursorHeight: 20,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_rounded),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Password',
                          focusColor: Colors.white,
                        ),
                        onSaved: (value) {
                          _userPassword = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        key: ValueKey('full name'),
                        textAlignVertical: TextAlignVertical(y: 0.1),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        cursorHeight: 20,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_sharp),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Full Name',
                          // border: OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.orange, width: 5.0),
                          //   borderRadius:
                          //       BorderRadius.all(Radius.circular(2.0)),
                          // ),
                        ),
                        onSaved: (value) {
                          _userFullName = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                            onPressed: _trySubmit,
                            color: Theme.of(context).accentColor.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            textColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
