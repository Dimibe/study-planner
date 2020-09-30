import 'package:flutter/material.dart';

class CWButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const CWButton({Key key, this.label, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 290,
      height: 60,
      child: RaisedButton(
        color: Theme.of(context).accentColor,
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
