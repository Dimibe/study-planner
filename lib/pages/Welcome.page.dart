import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';

import 'Register.page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SPDialog(
      title: 'Study Planner!',
      content: <Widget>[
        Text(
          'Willkommen bei Study Planner!',
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(bottom: 20.0)),
        Text(
          'Analysiere dein Studium und behalte alles im Überblick.',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(bottom: 20.0)),
        Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/welcome.png')),
        ),
        CWButton(
          label: 'Jetzt registrieren!',
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