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
  final String mandatoryText;
  final bool mandatory;
  final bool Function(String) validate;
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
    this.mandatoryText = 'Erforderlich',
    this.errorText = 'Eingabe nicht korrekt',
    this.mandatory = false,
    this.validate,
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
        mandatoryText = other.mandatoryText,
        mandatory = other.mandatory,
        validate = other.validate,
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
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        validator: _validator,
        keyboardType: _getKeyboardType(),
        inputFormatters: _getInputFormatters(),
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
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

  String _validator(String text) {
    if (widget.mandatory && (text == null || text.isEmpty)) {
      return widget.mandatoryText;
    } else if (widget.validate != null && !widget.validate(text)) {
      return widget.errorText;
    }
    return null;
  }
}

enum CWInputType { Integer, Decimal, Text }
