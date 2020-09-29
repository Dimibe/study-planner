import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CWTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  CWTextField(
      {this.controller,
      this.hintText,
      this.keyboardType,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      padding: EdgeInsets.all(8.0),
      child: TextField(
        inputFormatters: this.inputFormatters,
        keyboardType: this.keyboardType,
        decoration: InputDecoration(
          hoverColor: Colors.lightGreen,
          hintText: this.hintText,
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
