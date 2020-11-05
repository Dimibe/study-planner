import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'CWBaseWidget.dart';

class CWCheckBox extends CWBaseWidget<CWCheckBox> {
  final String label;
  final CheckBoxController controller;
  final bool initValue;

  const CWCheckBox({
    Key key,
    String id,
    @required this.label,
    @required this.controller,
    this.initValue = false,
  }) : super(id);

  CWCheckBox.copy(CWCheckBox other, CheckBoxController controller)
      : label = other.label,
        controller = controller,
        initValue = other.initValue,
        super(other.id, key: other.key);

  @override
  _CWCheckBoxState createState() => _CWCheckBoxState();

  @override
  CWCheckBox copy(CheckBoxController controller) {
    return CWCheckBox.copy(this, controller);
  }

  @override
  createController() => CheckBoxController();
}

class _CWCheckBoxState extends State<CWCheckBox> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.value == null) {
      setState(() {
        widget.controller.value = widget.initValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          onChanged: (value) => setState(() => widget.controller.value = value),
          value: widget.controller.value,
          activeColor: Theme.of(context).primaryColor,
        ),
        Text(
          FlutterI18n.translate(context, widget.label),
          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class CheckBoxController {
  bool value;

  set text(bool value) {
    this.value = value;
  }
}
