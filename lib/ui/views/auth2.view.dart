import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String _userEmail = '';
  bool _emailIsValid = true;
  String _userPassword = '';
  DateTime _selectedDate;
  bool _passwordIsValid = true;
  bool _ageConfirmed = false;
  bool _termsConfirmed = false;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // fbHandler = FirebaseHandler();
    // setDeeplinkClickHandler(fbHandler);
    // setDeeplinkBGHandler(fbHandler);
  }

  void _launchTermsURL() async {
    const url = 'http://withapp.io/policy/with_privacy_policy.htm';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Step> steps(BuildContext context) {
    return [
      Step(
        title: Text(
          'Credentials',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        isActive: _currentStep == 0,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              key: ValueKey('email'),
              // textAlignVertical: TextAlignVertical(y: 0.1),
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
              ),
              style: TextStyle(color: Colors.white),
              onSaved: (value) {
                _userEmail = value.trim();
              },
              onChanged: (value) {
                bool isValid = EmailValidator.validate(value.trim());
                setState(() {
                  _emailIsValid = isValid;
                });
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s+")),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              key: ValueKey('password'),
              validator: (value) {
                if (value.isEmpty || value.length < 7) {
                  return 'Password must be at least 7 characters long';
                }
                return null;
              },
              scrollPadding: EdgeInsets.zero,
              cursorHeight: 20,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_rounded),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'Password',
                focusColor: Colors.white,
              ),
              style: TextStyle(color: Colors.white),
              onSaved: (value) {
                _userPassword = value.trim();
              },
              onChanged: (value) {
                bool isValid = value.length >= 7;
                setState(() {
                  _passwordIsValid = isValid;
                });
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s+")),
              ],
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
                    Icon(Icons.verified_user),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'I am above 13 years old',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              CheckboxListTile(
                value: _termsConfirmed,
                checkColor: Colors.black,
                dense: true,
                contentPadding: EdgeInsets.all(0),
                onChanged: (value) {
                  setState(() {
                    _termsConfirmed = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.platform,
                title: Row(
                  children: [
                    Icon(Icons.policy),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'I agree to the terms of use',
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
            ],
          ),
        ),
      ),
      Step(
        state: _ageConfirmed && _termsConfirmed
            ? StepState.indexed
            : StepState.disabled,
        isActive: _currentStep == 2,
        title: const Text('Avatar'),
        subtitle: const Text("Error!"),
        content: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.red,
            )
          ],
        ),
      ),
    ];
  }

  Function getContinueFunction() {
    if (_emailIsValid && _passwordIsValid) {
      return () {
        setState(() {
          if (_currentStep < 2) {
            _currentStep++;
          }
        });
      };
    }
    return null;
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height,
            ),
            child: Container(
              // padding: StyleGuide.pageBleed,
              padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
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
                    ],
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Stepper(
                        physics: NeverScrollableScrollPhysics(),
                        currentStep: _currentStep,
                        onStepTapped: (step) {
                          setState(() {
                            _currentStep = step;
                          });
                        },
                        onStepContinue: getContinueFunction(),
                        controlsBuilder: (BuildContext context,
                            {VoidCallback onStepContinue,
                            VoidCallback onStepCancel}) {
                          // return Row(
                          //   children: [
                          //     FlatButton(
                          //       onPressed: onStepContinue,
                          //       child: Text('Done'),
                          //     ),
                          //   ],
                          // );
                          return SizedBox(
                            height: 0,
                          );
                        },
                        steps: steps(context),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
