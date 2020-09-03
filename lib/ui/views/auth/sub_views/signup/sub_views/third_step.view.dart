import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ThirdStep extends StatelessWidget {
  final picker = ImagePicker();
  final File selfie;
  final Function onFileChange;
  final Function onDisplayNameChange;
  final TextEditingController controller;
  final bool displayNameIsValid;

  ThirdStep({
    @required this.selfie,
    @required this.onFileChange,
    @required this.onDisplayNameChange,
    @required this.controller,
    @required this.displayNameIsValid,
  });

  Future _getImage(ImageSource src) async {
    var pickedFile = await picker.getImage(
      source: src,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      onFileChange(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  child: selfie != null
                      ? Image.file(
                          selfie,
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
                      color: Theme.of(context).accentColor,
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
                      color: Theme.of(context).accentColor,
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
          controller: controller,
          scrollPadding: EdgeInsets.zero,
          cursorHeight: 20,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_sharp),
            suffixIcon: displayNameIsValid
                ? Icon(Icons.check_circle)
                : Icon(Icons.error),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Display Name',
            focusColor: Colors.white,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: onDisplayNameChange,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r"^\s|\s\s+")),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
