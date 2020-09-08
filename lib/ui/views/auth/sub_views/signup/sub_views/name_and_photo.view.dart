import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:with_app/ui/shared/all.dart';

class NameAndPhoto extends StatelessWidget {
  final picker = ImagePicker();
  final File selfie;
  final Function onFileChange;
  final Function onDisplayNameChange;
  final TextEditingController controller;
  final bool displayNameIsValid;

  NameAndPhoto({
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
    Widget photoBtns = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FlatButton(
              color: Colors.white.withAlpha(selfie == null ? 30 : 0),
              padding: EdgeInsets.all(0),
              onPressed: () {
                _getImage(ImageSource.camera);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Camera'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: FlatButton(
              color: Colors.white.withAlpha(selfie == null ? 30 : 0),
              padding: EdgeInsets.all(0),
              onPressed: () {
                _getImage(ImageSource.gallery);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Device'),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget discardBtn = FlatButton(
      color: Colors.white.withAlpha(0),
      onPressed: () {
        onFileChange(null);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
          ),
          SizedBox(
            width: 7,
          ),
          Text('REMOVE'),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextInput(
          controller: controller,
          key: Key('display_name'),
          deny: RegExp(r"^\s|\s\s+"),
          onChange: onDisplayNameChange,
          validator: (value) {
            return value.length >= 3;
          },
          placeHolder: 'Display Name',
        ),
        VerticalSpacer(),
        selfie == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacer(),
                  Row(
                    children: [
                      Text(
                        'Add yor photo',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Icon(
                        Icons.error_outline,
                        size: 19,
                      ),
                    ],
                  ),
                  VerticalSpacer(),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        photoBtns,
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withAlpha(150),
                        child: ClipOval(
                          child: SizedBox(
                            width: 95,
                            height: 95,
                            child: Image.file(
                              selfie,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  discardBtn,
                ],
              ),
        VerticalSpacer(),
        VerticalSpacer(),
      ],
    );
  }
}
