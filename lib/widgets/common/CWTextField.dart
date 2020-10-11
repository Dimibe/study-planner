import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CWTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String helperText;
  final String errorText;
  final bool Function(String) validator;
  final double maxWidth;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;

  CWTextField(
      {Key key,
      @required this.labelText,
      this.controller,
      this.hintText,
      this.helperText,
      this.errorText = 'Erforderlich',
      this.validator,
      this.keyboardType,
      this.maxWidth = 300,
      this.maxLines = 1,
      this.inputFormatters})
      : super(key: key);

  /// Creates a copy
  CWTextField.copy(CWTextField other, {TextEditingController controller})
      : this.controller = controller ?? other.controller,
        labelText = other.labelText,
        hintText = other.hintText,
        helperText = other.helperText,
        errorText = other.errorText,
        validator = other.validator,
        keyboardType = other.keyboardType,
        maxWidth = other.maxWidth,
        maxLines = other.maxLines,
        inputFormatters = other.inputFormatters;

  @override
  _CWTextFieldState createState() => _CWTextFieldState();
}

class _CWTextFieldState extends State<CWTextField> {
  var _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _validate(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: this.widget.maxWidth,
      ),
      padding: EdgeInsets.all(8.0),
      child: TextField(
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        onChanged: _validate,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: _errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(style: BorderStyle.solid, color: Colors.red),
          ),
        ),
        controller: widget.controller,
      ),
    );
  }

  void _validate(String text) {
    if (widget.validator != null &&
        !widget.validator(text) &&
        _errorText == null) {
      setState(() => _errorText = widget.errorText);
    } else if (_errorText != null) {
      setState(() => _errorText = null);
    }
  }
}
