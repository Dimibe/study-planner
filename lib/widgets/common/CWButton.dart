import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../SPForm.dart';

class CWButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final EdgeInsets padding;
  final Color color;
  final double minWidth;
  final double minHeight;
  final double fontSize;
  final bool validateOnClick;

  const CWButton({
    Key key,
    this.label,
    this.color,
    this.onPressed,
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
            primary: color ?? Theme.of(context).accentColor,
            minimumSize: Size(minWidth ?? 290, minHeight ?? 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            var formState = SPForm.of(context);
            if (!validateOnClick || formState.formKey.currentState.validate()) {
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
