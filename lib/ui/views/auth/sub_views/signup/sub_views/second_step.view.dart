import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:with_app/with_icons.dart';
import '../../vertical_spacer.view.dart';

class SecondStep extends StatelessWidget {
  final bool ageConfirmed;
  final bool termsConfirmed;
  final Function onChangeAgeConfirmed;
  final Function onChangeTermsConfirmed;

  SecondStep({
    @required this.ageConfirmed,
    @required this.termsConfirmed,
    @required this.onChangeAgeConfirmed,
    @required this.onChangeTermsConfirmed,
  });

  void _launchTermsURL() async {
    const url = 'http://withapp.io/policy/with_privacy_policy.htm';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CheckboxListTile(
            value: ageConfirmed,
            checkColor: Colors.black,
            dense: true,
            contentPadding: EdgeInsets.all(0),
            onChanged: onChangeAgeConfirmed,
            controlAffinity: ListTileControlAffinity.platform,
            title: Row(
              children: [
                Icon(Icons.escalator_warning_outlined),
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
          VerticalSpacer(),
          CheckboxListTile(
            value: termsConfirmed,
            checkColor: Colors.black,
            contentPadding: EdgeInsets.all(0),
            onChanged: onChangeTermsConfirmed,
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
          VerticalSpacer(),
        ],
      ),
    );
  }
}
