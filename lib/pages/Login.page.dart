import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/navigator.service.dart';
import '../services/user.service.dart';
import '../utils/user_routing.dart';
import '../widgets/sp_modal_dialog.dart';
import '../widgets/common/cw_button.dart';
import '../widgets/common/cw_text.dart';
import '../widgets/common/cw_textfield.dart';

import '../main.dart';
import 'register.page.dart';

final GetIt getIt = GetIt.instance;

class LoginPage extends StatefulWidget with UserRouting {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SPModalDialog(
      title: 'title.login',
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
                  mandatory: true,
                  autofillHints: const [AutofillHints.email],
                  inputType: CWInputType.email,
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                ),
                CWTextField(
                  id: 'passowrd-input',
                  labelText: 'label.password',
                  obscureText: true,
                  textInputAction: TextInputAction.go,
                  autofillHints: const [AutofillHints.password],
                  controller: passwordController,
                  mandatory: true,
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
                  return const RegisterPage();
                },
              );
            },
            child: const CWText(
              'text.goToRegistration',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ];
      },
      actions: [
        CWButton(
          label: 'button.label.login',
          validateOnClick: true,
          onPressed: () async {
            await getIt<UserService>()
                .login(emailController.text, passwordController.text);
            MyApp.of(context)?.applyUserSettings(context);
            var page = await widget.getNextRoute();
            await getIt<NavigatorService>().navigateTo(page);
          },
        ),
      ],
    );
  }
}
