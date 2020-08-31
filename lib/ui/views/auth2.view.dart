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
  String _userEmail = '';
  String _userPassword = '';
  final _formKey = GlobalKey<FormState>();

  List<Step> steps(BuildContext context) {
    return [
      Step(
        title: Text(
          'Credentials',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
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
              cursorHeight: 20,
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
              height: 10,
            ),
          ],
        ),
      ),
      Step(
        isActive: false,
        state: StepState.disabled,
        title: const Text('Legal'),
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Home Address'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Postcode'),
            ),
          ],
        ),
      ),
      Step(
        state: StepState.disabled,
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
      body: SingleChildScrollView(
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
                      currentStep: 0,
                      controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                          VoidCallback onStepCancel}) {
                        return Row(
                          children: [
                            FlatButton(
                              onPressed: onStepContinue,
                              child: Text('CONTINUE'),
                            ),
                          ],
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
    );
  }
}
