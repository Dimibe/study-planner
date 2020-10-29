import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/Login.page.dart';
import 'package:study_planner/services/NavigatorService.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/utils/UserRouting.dart';
import 'package:study_planner/widgets/SPModalDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

final GetIt getIt = GetIt.instance;

class RegisterPage extends StatefulWidget with UserRouting {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SPModalDialog(
      title: Text('Registrieung'),
      minWidth: 100,
      padding: 15,
      content: (constrains) {
        return [
          AutofillGroup(
            child: Column(
              children: [
                CWTextField(
                  labelText: 'Email',
                  autofocus: true,
                  autofillHints: [AutofillHints.email],
                  controller: userNameController,
                  mandatory: true,
                ),
                CWTextField(
                  labelText: 'Passwort',
                  autofillHints: [AutofillHints.newPassword],
                  controller: passwordController,
                  obscureText: true,
                  mandatory: true,
                ),
                CWTextField(
                  labelText: 'Passwort wiederholen',
                  errorText: 'Passwort stimmt nicht überein',
                  obscureText: true,
                  mandatory: true,
                  validate: (text) => text == passwordController.text,
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () async {
              getIt<NavigatorService>().pop();
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
          validateOnClick: true,
          onPressed: () async {
            await getIt<UserService>()
                .register(userNameController.text, passwordController.text);
          },
        )
      ],
    );
  }
}
