import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/Login.page.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/widgets/SPModalDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SPModalDialog(
      title: Text('Registrieung'),
      minWidth: 100,
      padding: 15,
      content: (constrains) {
        return [
          CWTextField(
            labelText: 'Email',
            controller: userNameController,
          ),
          CWTextField(
            labelText: 'Passwort',
            obscureText: true,
            controller: passwordController,
          ),
          CWTextField(
            labelText: 'Passwort wiederholen',
            obscureText: true,
            // controller: passwordController,
          ),
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (context) {
                  return LoginPage();
                },
              );
            },
            child: Text('Hier geht\'s zurück zum Login'),
          ),
        ];
      },
      actions: <Widget>[
        CWButton(
          label: 'Registrieren',
          onPressed: () async {
            await GetIt.I<UserService>()
                .register(userNameController.text, passwordController.text);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
