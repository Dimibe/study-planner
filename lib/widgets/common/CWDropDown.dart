import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:study_planner/widgets/common/CWBaseWidget.dart';

class CWDropDown<T> extends CWBaseWidget<CWDropDown> {
  final List<T> items;
  final T initValue;
  final DropDownController controller;
  final void Function(T) onChanged;
  final double maxWidth;
  final String labelText;

  const CWDropDown(
      {Key key,
      String id,
      @required this.items,
      this.controller,
      this.initValue,
      this.onChanged,
      this.maxWidth = 300,
      this.labelText})
      : super(id);

  CWDropDown.copy(CWDropDown other, DropDownController<T> controller)
      : items = other.items,
        initValue = other.initValue,
        onChanged = other.onChanged,
        maxWidth = other.maxWidth,
        labelText = other.labelText,
        // ignore: unnecessary_this
        this.controller = controller,
        super(other.id, key: other.key);

  @override
  _CWDropDownState<T> createState() => _CWDropDownState<T>();

  @override
  CWDropDown copy(DropDownController<T> value) {
    return CWDropDown.copy(this, value);
  }

  @override
  dynamic createController() => DropDownController<T>();
}

class _CWDropDownState<T> extends State<CWDropDown<T>> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<T>(
            decoration: InputDecoration(
              labelText: FlutterI18n.translate(context, widget.labelText),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide:
                    BorderSide(style: BorderStyle.solid, color: Colors.red),
              ),
            ),
            items: widget.items.map(map).toList(),
            onChanged: (value) {
              setState(() => widget.controller.value = value);
              if (widget.onChanged != null) {
                widget.onChanged(value);
              }
            },
            value: widget.controller.value,
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<T> map(T obj) {
    return DropdownMenuItem<T>(
      value: obj,
      child: Text('$obj'),
    );
  }
}

class DropDownController<T> {
  T value;

  set text(T value) {
    this.value = value;
  }
}
