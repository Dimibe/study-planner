import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWAppState.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWText.dart';

import 'Register.page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends CWState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SPDialog(
      content: <Widget>[
        Padding(padding: EdgeInsets.only(bottom: 20.0)),
        CWText(
          'text.welcomeToStudyPlanner',
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(bottom: 20.0)),
        CWText(
          'text.welcomeSubHeading',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(bottom: 20.0)),
        Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/images/welcome.png')),
        ),
        CWButton(
          label: 'button.label.registerNow',
          padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return RegisterPage();
              },
            );
          },
        ),
      ],
    );
  }
}
