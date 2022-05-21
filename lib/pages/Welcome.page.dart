import 'package:flutter/material.dart';
import 'package:study_planner/widgets/sp_dialog.dart';
import 'package:study_planner/widgets/common/cw_app_state.dart';
import 'package:study_planner/widgets/common/cw_button.dart';
import 'package:study_planner/widgets/common/cw_text.dart';

import 'register.page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends CWState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SPDialog(
      content: <Widget>[
        const Padding(padding: EdgeInsets.only(bottom: 20.0)),
        CWText(
          'text.welcomeToStudyPlanner',
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20.0)),
        CWText(
          'text.welcomeSubHeading',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20.0)),
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(8.0),
          child: const Image(image: AssetImage('assets/images/welcome.png')),
        ),
        CWButton(
          label: 'button.label.registerNow',
          padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return const RegisterPage();
              },
            );
          },
        ),
      ],
    );
  }
}
