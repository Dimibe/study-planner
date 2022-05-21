import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import './login.page.dart';
import '../services/navigator.service.dart';
import '../services/user.service.dart';
import '../utils/user_routing.dart';
import '../widgets/sp_modal_dialog.dart';
import '../widgets/common/cw_button.dart';
import '../widgets/common/cw_text.dart';
import '../widgets/common/cw_textfield.dart';

import '../main.dart';

final GetIt getIt = GetIt.instance;

class RegisterPage extends StatefulWidget with UserRouting {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SPModalDialog(
      title: 'title.registration',
      minWidth: 100,
      padding: 15,
      content: (constrains) {
        return [
          AutofillGroup(
            child: Column(
              children: [
                CWTextField(
                  id: 'mail-input',
                  labelText: 'label.mail',
                  autofocus: true,
                  inputType: CWInputType.email,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  controller: userNameController,
                  mandatory: true,
                ),
                CWTextField(
                  id: 'password-input',
                  labelText: 'label.password',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  controller: passwordController,
                  obscureText: true,
                  mandatory: true,
                ),
                CWTextField(
                  id: 'confirm-pw-input',
                  textInputAction: TextInputAction.go,
                  labelText: 'label.confirmPassword',
                  errorText: 'error.passwordNotMatching',
                  obscureText: true,
                  mandatory: true,
                  validate: (text) => text == passwordController.text,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              getIt<NavigatorService>().pop();
              await showDialog(
                context: context,
                builder: (context) {
                  return const LoginPage();
                },
              );
            },
            child: const CWText('text.backToLogin'),
          ),
        ];
      },
      actions: <Widget>[
        CWButton(
          label: 'button.label.register',
          validateOnClick: true,
          onPressed: () async {
            await getIt<UserService>()
                .register(userNameController.text, passwordController.text);
            MyApp.of(context)?.applyUserSettings(context);
            var page = await widget.getNextRoute();
            await getIt<NavigatorService>().navigateTo(page);
          },
        )
      ],
    );
  }
}
