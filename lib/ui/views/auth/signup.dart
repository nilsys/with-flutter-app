import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:with_app/core/view_models/user.vm.dart';
import 'package:with_app/core/models/user.model.dart';
import 'package:with_app/core/models/user_stories.model.dart';
import 'package:with_app/ui/shared/toaster.dart';
import 'package:with_app/ui/views/home.view.dart';
import 'package:with_app/with_icons.dart';
import 'auth_hero.dart';
import 'text_input.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'display_name': TextEditingController(),
  };
  final pageController = PageController(
    initialPage: 1,
  );
  bool _emailIsValid = false;
  bool _passwordIsValid = false;
  bool _displayNameIsValid = false;
  bool _ageConfirmed = false;
  bool _termsConfirmed = false;
  int _currentStep = 0;
  File _selfie;
  UserVM _userVM;

  @override
  void initState() {
    super.initState();
    _userVM = new UserVM();
    if (_auth.currentUser != null) {
      /***
        using this.context instaed of context.
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
    // fbHandler = FirebaseHandler();
    // setDeeplinkClickHandler(fbHandler);
    // setDeeplinkBGHandler(fbHandler);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controllers['email'].dispose();
    controllers['password'].dispose();
    controllers['display_name'].dispose();
    super.dispose();
  }

  void _launchTermsURL() async {
    const url = 'http://withapp.io/policy/with_privacy_policy.htm';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _getImage(ImageSource src) async {
    var pickedFile = await picker.getImage(
      source: src,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      setState(() {
        _selfie = File(pickedFile.path);
      });
    }
  }

  Widget _verticalSpacer = SizedBox(
    height: 12,
  );

  @override
  Widget build(BuildContext context) {
    Future<void> _trySubmit() async {
      final isValid = _emailIsValid &&
          _passwordIsValid &&
          _ageConfirmed &&
          _termsConfirmed &&
          _displayNameIsValid;
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
                  stories: new UserStories(
                    owner: new List(),
                    following: new List(),
                    viewing: new List(),
                  ),
                  leads: new List(),
                  profileImage: _url,
                ),
                userCredentials.user.uid);
          }
        } on PlatformException catch (err) {
          print(err);
        } catch (err) {
          Toaster(
            // titleText: Text("Oops..."),
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
          if (_ageConfirmed && _termsConfirmed) {
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
        content: Column(
          children: <Widget>[
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
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      Step(
        isActive: _currentStep == 1,
        state: _emailIsValid && _passwordIsValid
            ? StepState.indexed
            : StepState.disabled,
        title: Text('Legal'),
        content: Transform.translate(
          offset: Offset(0, -10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CheckboxListTile(
                value: _ageConfirmed,
                checkColor: Colors.black,
                dense: true,
                contentPadding: EdgeInsets.all(0),
                onChanged: (value) {
                  setState(() {
                    _ageConfirmed = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.platform,
                title: Row(
                  children: [
                    Icon(Icons.escalator_warning_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'I am above 13 years old',
                      style: Theme.of(this.context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              _verticalSpacer,
              CheckboxListTile(
                value: _termsConfirmed,
                checkColor: Colors.black,
                contentPadding: EdgeInsets.all(0),
                onChanged: (value) {
                  setState(() {
                    _termsConfirmed = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.platform,
                title: Row(
                  children: [
                    Icon(With.gavel),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'I agree to the\nterms of use',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    IconButton(
                      onPressed: _launchTermsURL,
                      icon: Icon(Icons.link),
                      color: Theme.of(context).accentColor,
                    )
                  ],
                ),
              ),
              _verticalSpacer,
            ],
          ),
        ),
      ),
      Step(
        state: _ageConfirmed && _termsConfirmed
            ? StepState.indexed
            : StepState.disabled,
        isActive: _currentStep == 2,
        title: const Text('Identity'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withAlpha(150),
                  child: ClipOval(
                    child: SizedBox(
                      width: 112.0,
                      height: 112.0,
                      child: _selfie != null
                          ? Image.file(
                              _selfie,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'images/selfie.png',
                              fit: BoxFit.cover,
                              color: Colors.white,
                              colorBlendMode: BlendMode.color,
                            ),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _getImage(ImageSource.gallery);
                        },
                        icon: Icon(
                          Icons.phone_android,
                          size: 25.0,
                          color: Theme.of(this.context).accentColor,
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),
                      Divider(
                        color: Colors.white.withAlpha(80),
                        thickness: 2,
                        // height: 50,
                        // indent: 15,
                        // endIndent: 15,
                      ),
                      IconButton(
                        onPressed: () {
                          _getImage(ImageSource.camera);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 25.0,
                          color: Theme.of(this.context).accentColor,
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              key: ValueKey('display_name'),
              // validator: (value) {
              //   if (value.length < 3) {
              //     return 'Please enter at least 3 charecters';
              //   }
              //   return null;
              // },
              controller: controllers['display_name'],
              scrollPadding: EdgeInsets.zero,
              cursorHeight: 20,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_sharp),
                suffixIcon: _displayNameIsValid
                    ? Icon(Icons.check_circle)
                    : Icon(Icons.error),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'Display Name',
                focusColor: Colors.white,
              ),
              style: TextStyle(color: Colors.white),
              // onSaved: (value) {
              //   _displayName = value.trim();
              // },
              onChanged: (value) {
                bool isValid = value.length > 2;
                setState(() {
                  _displayNameIsValid = isValid;
                });
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"^\s|\s\s+")),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ];

    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).requestFocus(new FocusNode());
        FocusScope.of(this.context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Future.delayed(Duration(milliseconds: 200), () {
                    FocusScope.of(this.context).unfocus();
                  });
                },
                onStepContinue: getContinueFunction(),
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: onStepContinue,
                      child: Text(
                          _currentStep == 2 ? 'CREATE MY ACCOUNT' : 'CONFIRM'),
                      // color: Theme.of(context).accentColor,
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
            // Expanded(
            //   child: Container(
            //     child: Text('Sign in instead'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
