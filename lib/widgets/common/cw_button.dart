import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../sp_form.dart';

class CWButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final EdgeInsets? padding;
  final Color? color;
  final double? minWidth;
  final double? minHeight;
  final double? fontSize;
  final bool validateOnClick;

  const CWButton({
    Key? key,
    required this.label,
    this.color,
    required this.onPressed,
    this.padding,
    this.minWidth,
    this.minHeight,
    this.fontSize,
    this.validateOnClick = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
            minimumSize: Size(minWidth ?? 290, minHeight ?? 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            var formState = SPForm.of(context).formKey.currentState;
            if (!validateOnClick ||
                (formState != null && formState.validate())) {
              onPressed();
            }
          },
          child: Text(
            FlutterI18n.translate(context, label),
            style: TextStyle(fontSize: fontSize ?? 20),
          ),
        ),
      ),
    );
  }
}
