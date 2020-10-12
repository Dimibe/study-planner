import 'package:flutter/material.dart';
import 'package:study_planner/widgets/common/CWBase.dart';

class CWDropDown<T> extends StatefulWidget implements CWBase {
  final String semanticLabel;
  final List<T> items;
  final T initValue;
  final DropDownController controller;
  final double maxWidth;
  final String labelText;

  const CWDropDown(
      {Key key,
      @required this.items,
      this.controller,
      this.semanticLabel,
      this.initValue,
      this.maxWidth,
      this.labelText})
      : super(key: key);

  CWDropDown.copy(CWDropDown other, dynamic controller)
      : semanticLabel = other.semanticLabel,
        items = other.items,
        initValue = other.initValue,
        maxWidth = other.maxWidth,
        labelText = other.labelText,
        this.controller = controller;

  @override
  _CWDropDownState<T> createState() => _CWDropDownState<T>();

  @override
  CWDropDown copy(value) {
    return CWDropDown.copy(this, value);
  }

  @override
  createController() => DropDownController<T>();

  @override
  get id => semanticLabel;
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
        //padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<T>(
            decoration: InputDecoration(
              labelText: widget.labelText,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide:
                    BorderSide(style: BorderStyle.solid, color: Colors.red),
              ),
            ),
            items: widget.items.map(map).toList(),
            onChanged: (value) =>
                setState(() => widget.controller.value = value),
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
