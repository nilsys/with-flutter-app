import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_app/core/models/user_stories.model.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/home/home.view.dart';
import '../auth_hero.view.dart';
import 'sub_views/credentials.view.dart';
import 'sub_views/name_and_photo.view.dart';
import 'sub_views/age.view.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _auth = FirebaseAuth.instance;

  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'display_name': TextEditingController(),
  };
  ScrollControl scrollController = ScrollControl();
  bool _emailIsValid = false;
  bool _passwordIsValid = false;
  bool _displayNameIsValid = false;
  DateTime _dayOfBirth;
  int _currentStep = 0;
  File _selfie;
  UserVM _userVM;

  @override
  void initState() {
    super.initState();
    scrollController.init();
    DateTime now = DateTime.now();
    _dayOfBirth = DateTime(now.year - 20);
    _userVM = UserVM();
    if (_auth.currentUser != null) {
      /***
        using this.context instaed of just context.
        see https://stackoverflow.com/questions/56927095/flutter-navigator-argument-type-context-cant-be-assigned-to-the-parameter-ty?rq=1
      ***/
      Navigator.pushNamed(this.context, HomeView.route);
    } else {
      _auth.authStateChanges().listen((user) {
        if (user != null) {
          Navigator.pushNamed(this.context, HomeView.route);
        }
      });
    }
  }

  @override
  void dispose() {
    controllers['email'].dispose();
    controllers['password'].dispose();
    controllers['display_name'].dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _trySubmit() async {
      final isValid = _emailIsValid && _passwordIsValid && _displayNameIsValid;
      FocusScope.of(this.context).unfocus();

      if (isValid) {
        try {
          UserCredential userCredentials =
              await _auth.createUserWithEmailAndPassword(
            email: controllers['email'].text.trim(),
            password: controllers['password'].text.trim(),
          );
          String _url =
              await _userVM.uploadAvatar(_selfie, userCredentials.user.uid);
          if (_url != null) {
            _userVM.addUser(
                new UserModel(
                  id: userCredentials.user.uid,
                  email: userCredentials.user.email,
                  displayName: controllers['display_name'].text.trim(),
                  dayOfBirth: _dayOfBirth,
                  profileImage: _url,
                  stories: UserStories(),
                ),
                userCredentials.user.uid);
          }
        } on PlatformException catch (err) {
          print(err);
        } catch (err) {
          Toaster(
            icon: Icon(Icons.error),
            content: Text(err.message),
          )..show(context);
        }
      }
    }

    Function getContinueFunction() {
      switch (_currentStep) {
        case 0:
          if (_emailIsValid && _passwordIsValid) {
            return () {
              setState(() {
                _currentStep++;
                Future.delayed(Duration(milliseconds: 200), () {
                  FocusScope.of(this.context).unfocus();
                });
              });
            };
          }
          return null;
        case 1:
          return () {
            setState(() {
              _currentStep++;
            });
            scrollController.scrollToBottom();
          };
        case 2:
          if (_displayNameIsValid && _selfie != null) {
            return () {
              _trySubmit();
              Future.delayed(Duration(milliseconds: 200), () {
                FocusScope.of(this.context).unfocus();
              });
            };
          }
          return null;
        default:
          return null;
      }
    }

    final steps = [
      Step(
        title: Text(
          'Credentials',
          style: Theme.of(this.context).textTheme.bodyText2,
        ),
        isActive: _currentStep == 0,
        state: StepState.indexed,
        content: Credentials(
          onChangeEmail: (value) {
            bool isValid = EmailValidator.validate(value.trim());
            setState(() {
              _emailIsValid = isValid;
            });
          },
          onChangePassword: (value) {
            bool isValid = value.length >= 7;
            setState(() {
              _passwordIsValid = isValid;
            });
          },
          controllerEmail: controllers['email'],
          controllerPassword: controllers['password'],
        ),
      ),
      Step(
        isActive: _currentStep == 1,
        state: _emailIsValid && _passwordIsValid
            ? StepState.indexed
            : StepState.disabled,
        title: Text('Day of birth'),
        content: Age(
          onChange: (DateTime newDate, _) {
            setState(() {
              _dayOfBirth = newDate;
            });
          },
        ),
      ),
      Step(
        state: _emailIsValid && _passwordIsValid
            ? StepState.indexed
            : StepState.disabled,
        isActive: _currentStep == 2,
        title: const Text('Name & Photo'),
        content: NameAndPhoto(
          selfie: _selfie,
          onFileChange: (filePath) {
            setState(() {
              _selfie = filePath;
            });
          },
          onDisplayNameChange: (value) {
            bool isValid = value.length > 2;
            setState(() {
              _displayNameIsValid = isValid;
            });
          },
          controller: controllers['display_name'],
          displayNameIsValid: _displayNameIsValid,
        ),
      ),
    ];

    return GestureDetector(
      onTap: () {
        FocusScope.of(this.context).unfocus();
      },
      child: SingleChildScrollView(
        controller: scrollController.controller,
        child: Column(
          children: [
            AuthHero(
              text: 'Create Acount',
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Stepper(
                physics: NeverScrollableScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) {
                  setState(() {
                    _currentStep = step;
                  });
                  Timer(Duration(milliseconds: 200), () {
                    FocusScope.of(this.context).unfocus();
                  });
                  scrollController.scrollToBottom();
                },
                onStepContinue: getContinueFunction(),
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: onStepContinue,
                      child: Text(
                        _currentStep == 2 ? 'CREATE MY ACCOUNT' : 'CONFIRM',
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      textColor: Colors.black,
                    ),
                  );
                },
                steps: steps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
