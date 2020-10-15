import 'package:flutter/material.dart';

class StorySettings extends StatefulWidget {
  final Function goToTimeline;

  StorySettings({
    @required this.goToTimeline,
  });

  @override
  _StorySettingsState createState() => _StorySettingsState();
}

class _StorySettingsState extends State<StorySettings> {
  // ScrollController scrollController = ScrollController();
  final Map<String, TextEditingController> controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // scrollController.dispose();
    controllers['title'].dispose();
    controllers['description'].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // @swidget
    // Widget title() => CustomTextInput(
    //       controller: controllers['email'],
    //       key: Key('email'),
    //       deny: RegExp(r"\s+"),
    //       onChange: (value) {
    //         // bool isValid = EmailValidator.validate(value.trim());
    //         // setState(() {
    //         //   _emailIsValid = isValid;
    //         // });
    //       },
    //       validator: (value) {
    //         // return EmailValidator.validate(value.trim());
    //         return true;
    //       },
    //       placeHolder: 'Email',
    //       onTap: scrollController.scrollToBottom,
    //     );

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
