import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CWTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String helperText;
  final double maxWidth;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  CWTextField(
      {Key key,
      this.controller,
      this.labelText,
      this.hintText,
      this.helperText,
      this.keyboardType,
      this.maxWidth = 300,
      this.inputFormatters})
      : super(key: key);

  /// Creates a copy
  CWTextField.copy(CWTextField other, {TextEditingController controller})
      : this.controller = controller ?? other.controller,
        labelText = other.labelText,
        hintText = other.hintText,
        helperText = other.helperText,
        keyboardType = other.keyboardType,
        maxWidth = other.maxWidth,
        inputFormatters = other.inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: this.maxWidth,
      ),
      padding: EdgeInsets.all(8.0),
      child: TextField(
        inputFormatters: this.inputFormatters,
        keyboardType: this.keyboardType,
        decoration: InputDecoration(
          labelText: this.labelText,
          hintText: this.hintText,
          helperText: this.helperText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(style: BorderStyle.solid, color: Colors.red),
          ),
        ),
        controller: controller,
      ),
    );
  }
}
