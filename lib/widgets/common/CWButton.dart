import 'package:flutter/material.dart';

class CWButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final EdgeInsets padding;
  final Color color;
  final double minWidth;
  final double minHeight;
  final double fontSize;

  const CWButton({
    Key key,
    this.label,
    this.color,
    this.onPressed,
    this.padding,
    this.minWidth,
    this.minHeight,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.padding ?? const EdgeInsets.all(8.0),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: this.color ?? Theme.of(context).accentColor,
            minimumSize: Size(this.minWidth ?? 290, this.minHeight ?? 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: this.onPressed,
          child: Text(
            this.label,
            style: TextStyle(fontSize: this.fontSize ?? 20),
          ),
        ),
      ),
    );
  }
}
