import 'package:flutter/material.dart';

class CWButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final EdgeInsets padding;
  final Color color;

  const CWButton(
      {Key key, this.label, this.color, this.onPressed, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 290,
      height: 60,
      padding: this.padding,
      child: RaisedButton(
        color: this.color ?? Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onPressed: this.onPressed,
        child: Text(
          this.label,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
