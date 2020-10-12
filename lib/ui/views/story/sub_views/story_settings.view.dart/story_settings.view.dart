import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:with_app/ui/shared/all.dart';

class StorySettings extends StatefulWidget {
  final Function goToTimeline;

  StorySettings({
    @required this.goToTimeline,
  });

  @override
  _StorySettingsState createState() => _StorySettingsState();
}

class _StorySettingsState extends State<StorySettings> {
  ScrollControl scrollController = ScrollControl();
  final Map<String, TextEditingController> controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    scrollController.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    controllers['title'].dispose();
    controllers['description'].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    @swidget
    Widget title() => CustomTextInput(
          controller: controllers['email'],
          key: Key('email'),
          deny: RegExp(r"\s+"),
          onChange: (value) {
            // bool isValid = EmailValidator.validate(value.trim());
            // setState(() {
            //   _emailIsValid = isValid;
            // });
          },
          validator: (value) {
            // return EmailValidator.validate(value.trim());
            return true;
          },
          placeHolder: 'Email',
          onTap: scrollController.scrollToBottom,
        );

    return GestureDetector(
      onTap: () {
        FocusScope.of(this.context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Story Settings',
            style: Theme.of(context).textTheme.headline2,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: widget.goToTimeline,
          ),
        ),
        body: Column(
          children: [
            Text('StorySettings View'),
            FlatButton(
              onPressed: widget.goToTimeline,
              child: Text('Back to Timeline'),
            ),
          ],
        ),
      ),
    );
  }
}
