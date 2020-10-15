import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:with_app/ui/shared/all.dart';

class Credentials extends StatelessWidget {
  final Function onChangeEmail;
  final Function onChangePassword;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;

  Credentials({
    @required this.onChangeEmail,
    @required this.onChangePassword,
    @required this.controllerEmail,
    @required this.controllerPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomTextInput(
          controller: controllerEmail,
          key: Key('email'),
          deny: RegExp(r"\s+"),
          onChange: onChangeEmail,
          validator: (value) {
            return EmailValidator.validate(value.trim());
          },
          placeHolder: 'Email',
        ),
        VerticalSpacer(),
        CustomTextInput(
          controller: controllerPassword,
          key: Key('password'),
          deny: RegExp(r"\s+"),
          obscureText: true,
          onChange: onChangePassword,
          validator: (value) {
            return value.length >= 7;
          },
          placeHolder: 'Password',
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
