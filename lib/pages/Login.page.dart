import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/widgets/SPModalDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

import 'Register.page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SPModalDialog(
      title: Text('Login'),
      minWidth: 100,
      padding: 15,
      content: (constrains) {
        return [
          CWTextField(
            labelText: 'Email',
            controller: emailController,
          ),
          CWTextField(
            labelText: 'Passwort',
            controller: passwordController,
          ),
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (context) {
                  return RegisterPage();
                },
              );
            },
            child: Text(
              'Hier gehts zur Registrierung',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ];
      },
      actions: <Widget>[
        CWButton(
          label: 'Login',
          onPressed: () async {
            await GetIt.I<UserService>()
                .login(emailController.text, passwordController.text);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
