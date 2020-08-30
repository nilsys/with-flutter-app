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
import 'package:provider/provider.dart';
import 'package:with_app/core/models/user_stories.model.dart';
import 'package:with_app/core/services/auth.dart';
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
  String _userFirstName = '';
  String _userLastName = '';
  String _userDisplayName = '';
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _displayNameController = TextEditingController();
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
    _firstNameController.addListener(() {
      _displayNameController.text =
          '${_firstNameController.text} ${_lastNameController.text}';
    });
    _lastNameController.addListener(() {
      _displayNameController.text =
          '${_firstNameController.text} ${_lastNameController.text}';
    });
    // fbHandler = FirebaseHandler();
    // setDeeplinkClickHandler(fbHandler);
    // setDeeplinkBGHandler(fbHandler);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _displayNameController.dispose();
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
            firstName: _userFirstName,
            lastName: _userLastName,
            displayName: _userDisplayName,
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
                    key: ValueKey('first name'),
                    controller: _firstNameController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    onSaved: (value) {
                      _userFirstName = value.trim();
                    },
                  ),
                  TextFormField(
                    key: ValueKey('last name'),
                    controller: _lastNameController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    onSaved: (value) {
                      _userLastName = value.trim();
                    },
                  ),
                  TextFormField(
                    key: ValueKey('display name'),
                    controller: _displayNameController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    onSaved: (value) {
                      _userDisplayName = value.trim();
                    },
                  ),
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
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value.trim();
                    },
                  ),
                  FlatButton(
                    onPressed: _trySubmit,
                    color: Colors.orange,
                    child: Text('Signup'),
                  ),
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
