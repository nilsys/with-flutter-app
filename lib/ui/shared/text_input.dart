import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final Key key;
  final Function validator;
  final Function onChange;
  final RegExp deny;
  final String placeHolder;
  final bool obscureText;
  final Function onTap;

  CustomTextInput({
    @required this.key,
    @required this.placeHolder,
    @required this.deny,
    @required this.validator,
    @required this.onChange,
    @required this.controller,
    this.obscureText = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      onTap: onTap,
      controller: controller,
      cursorHeight: 20,
      keyboardType: TextInputType.emailAddress,
      obscureText: obscureText,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: placeHolder,
        contentPadding: EdgeInsets.fromLTRB(17.0, 0, 0, 0),
        suffixIcon: validator(controller.value.text)
            ? Icon(
                Icons.check,
                size: 19,
                color: Colors.white.withAlpha(250),
              )
            : Icon(
                Icons.error_outline,
                size: 19,
                color: Colors.white.withAlpha(120),
              ),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: onChange,
      inputFormatters: [
        FilteringTextInputFormatter.deny(deny),
      ],
    );
  }
}
