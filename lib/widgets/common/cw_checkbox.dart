import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'cw_base_widget.dart';

class CWCheckBox extends CWBaseWidget<CWCheckBox> {
  final String label;
  final CheckBoxController controller;
  final bool initValue;
  final String? tooltip;

  const CWCheckBox({
    super.key,
    required String id,
    required this.label,
    required this.controller,
    this.initValue = false,
    this.tooltip,
  }) : super(id);

  CWCheckBox.copy(CWCheckBox other, this.controller)
      : label = other.label,
        initValue = other.initValue,
        tooltip = other.tooltip,
        super(other.id, key: other.key);

  @override
  State<CWCheckBox> createState() => _CWCheckBoxState();

  @override
  CWCheckBox copy(CheckBoxController controller) {
    return CWCheckBox.copy(this, controller);
  }

  @override
  dynamic createController() => CheckBoxController();
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
          style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        ),
        if (widget.tooltip != null)
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: null,
            tooltip: FlutterI18n.translate(context, widget.tooltip!),
          ),
      ],
    );
  }
}

class CheckBoxController {
  bool? value;

  set text(bool value) {
    this.value = value;
  }
}
