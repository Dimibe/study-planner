import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_planner/widgets/common/CWBase.dart';

class CWTextField extends StatefulWidget implements CWBase<CWTextField> {
  final TextEditingController controller;
  final String semanticLabel;
  final String labelText;
  final String hintText;
  final String helperText;
  final String errorText;
  final bool Function(String) validator;
  final double maxWidth;
  final int maxLines;
  final bool obscureText;
  final List<String> autofillHints;
  final bool autofocus;
  final CWInputType inputType;

  const CWTextField({
    Key key,
    @required this.labelText,
    this.semanticLabel,
    this.controller,
    this.hintText,
    this.helperText,
    this.errorText = 'Erforderlich',
    this.validator,
    this.maxWidth = 300,
    this.maxLines = 1,
    this.obscureText = false,
    this.autofillHints,
    this.autofocus = false,
    this.inputType = CWInputType.Text,
  }) : super(key: key);

  /// Creates a copy
  CWTextField.copy(CWTextField other, {TextEditingController controller})
      : this.controller = controller ?? other.controller,
        semanticLabel = other.semanticLabel,
        labelText = other.labelText,
        hintText = other.hintText,
        helperText = other.helperText,
        errorText = other.errorText,
        validator = other.validator,
        maxWidth = other.maxWidth,
        maxLines = other.maxLines,
        obscureText = other.obscureText,
        autofillHints = other.autofillHints,
        autofocus = other.autofocus,
        inputType = other.inputType;

  @override
  CWTextField copy(controller) {
    return CWTextField.copy(this, controller: controller);
  }

  @override
  _CWTextFieldState createState() => _CWTextFieldState();

  @override
  createController() => TextEditingController();

  @override
  get id => semanticLabel;
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
      child: TextFormField(
        autofocus: widget.autofocus,
        autofillHints: widget.autofillHints,
        onChanged: _validate,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        keyboardType: _getKeyboardType(),
        inputFormatters: _getInputFormatters(),
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

  TextInputType _getKeyboardType() {
    if ({CWInputType.Decimal, CWInputType.Integer}.contains(widget.inputType)) {
      return TextInputType.numberWithOptions(
        decimal: widget.inputType == CWInputType.Decimal,
        signed: false,
      );
    }
    return null;
  }

  List<TextInputFormatter> _getInputFormatters() {
    if (CWInputType.Integer == widget.inputType) {
      return [FilteringTextInputFormatter.digitsOnly];
    } else if (CWInputType.Decimal == widget.inputType) {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'(\d|\.|,)')),
        FilteringTextInputFormatter.deny(RegExp(r','), replacementString: '.'),
      ];
    }
    return null;
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

enum CWInputType { Integer, Decimal, Text }
