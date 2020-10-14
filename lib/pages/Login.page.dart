import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/widgets/SPModalDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userNameController.text = 'dimitribegnis@gmail.com';

    return SPModalDialog(
      title: Text('Login'),
      minWidth: 100,
      padding: 15,
      content: (constrains) {
        return [
          CWTextField(
            labelText: 'Benutzername',
            controller: userNameController,
          ),
          CWTextField(
            labelText: 'Passwort',
            controller: passwordController,
          ),
          FlatButton(
            onPressed: () {},
            child: Text('Hier gehts zur Registrierung'),
          ),
        ];
      },
      actions: <Widget>[
        CWButton(
          label: 'Login',
          onPressed: () async {
            await GetIt.I<UserService>()
                .login(userNameController.text, passwordController.text);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
