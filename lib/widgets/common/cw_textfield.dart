import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import './cw_base_widget.dart';

class CWTextField extends CWBaseWidget<CWTextField> {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final String? helperText;
  final String errorText;
  final String mandatoryText;
  final bool mandatory;
  final bool Function(String?)? validate;
  final double maxWidth;
  final int maxLines;
  final bool obscureText;
  final List<String>? autofillHints;
  final bool autofocus;
  final CWInputType inputType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const CWTextField({
    super.key,
    required String id,
    required this.labelText,
    this.controller,
    this.hintText,
    this.helperText,
    this.mandatoryText = 'required',
    this.errorText = 'error.notcorrect',
    this.mandatory = false,
    this.validate,
    this.maxWidth = 300,
    this.maxLines = 1,
    this.obscureText = false,
    this.autofillHints,
    this.autofocus = false,
    this.inputType = CWInputType.text,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
  }) : super(id);

  /// Creates a copy
  CWTextField.copy(CWTextField other, {TextEditingController? controller})
      // ignore: unnecessary_this
      : this.controller = controller ?? other.controller,
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
        inputType = other.inputType,
        textInputAction = other.textInputAction,
        onFieldSubmitted = other.onFieldSubmitted,
        focusNode = other.focusNode,
        super(other.id, key: other.key);

  @override
  CWTextField copy(TextEditingController controller) {
    return CWTextField.copy(this, controller: controller);
  }

  @override
  State<CWTextField> createState() => _CWTextFieldState();

  @override
  dynamic createController() => TextEditingController();
}

class _CWTextFieldState extends State<CWTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
      ),
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        autofillHints: widget.autofillHints,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        validator: _validator,
        keyboardType: _getKeyboardType(),
        inputFormatters: _getInputFormatters(),
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, widget.labelText) +
              (widget.mandatory ? '*' : ''),
          hintText: widget.hintText == null
              ? null
              : FlutterI18n.translate(context, widget.hintText!),
          helperText: widget.helperText == null
              ? null
              : FlutterI18n.translate(context, widget.helperText!),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:
                const BorderSide(style: BorderStyle.solid, color: Colors.red),
          ),
        ),
        controller: widget.controller,
      ),
    );
  }

  TextInputType _getKeyboardType() {
    if ({CWInputType.decimal, CWInputType.integer}.contains(widget.inputType)) {
      return TextInputType.numberWithOptions(
        decimal: widget.inputType == CWInputType.decimal,
        signed: false,
      );
    } else if (CWInputType.email == widget.inputType) {
      return TextInputType.emailAddress;
    }
    return TextInputType.text;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (CWInputType.integer == widget.inputType) {
      return [FilteringTextInputFormatter.digitsOnly];
    } else if (CWInputType.decimal == widget.inputType) {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'(\d|\.|,)')),
        FilteringTextInputFormatter.deny(RegExp(r','), replacementString: '.'),
      ];
    }
    return null;
  }

  String? _validator(String? text) {
    if (widget.mandatory && (text == null || text.isEmpty)) {
      return FlutterI18n.translate(context, widget.mandatoryText);
    } else if (widget.validate != null && !widget.validate!(text)) {
      return FlutterI18n.translate(context, widget.errorText);
    }
    return null;
  }
}

enum CWInputType { integer, decimal, text, email }
