import 'package:flutter/material.dart';

import 'CWTextField.dart';

class CWDynamicContainer extends StatefulWidget {
  final bool showHideOption;
  final bool showAddOption;
  final CWDynamicController contoller;
  final List<CWTextField> children;
  final EdgeInsets padding;

  const CWDynamicContainer({
    Key key,
    this.showHideOption,
    this.showAddOption,
    this.contoller,
    this.children,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CWDynamicContainerState();
}

class _CWDynamicContainerState extends State<CWDynamicContainer> {
  List<_CWDynamicRow> rows = [];

  @override
  void initState() {
    super.initState();
    addEmptyRow();
  }

  void addEmptyRow() {
    Map<String, TextEditingController> map = {};

    var widgets = <CWTextField>[];

    for (CWTextField textField in widget.children) {
      var controller = TextEditingController();
      map.putIfAbsent(textField.labelText, () => controller);
      var copy = CWTextField.copy(textField, controller: controller);
      widgets.add(copy);
    }
    widget.contoller.addRow(map);
    setState(() => rows.add(_CWDynamicRow(children: widgets)));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    _children.addAll(rows);
    _children.add(
      Padding(
        padding: widget.padding,
        child: Container(
          color: Theme.of(context).accentColor,
          child: IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: addEmptyRow,
          ),
        ),
      ),
    );

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children,
      ),
    );
  }
}

class CWDynamicController {
  List<Map<String, TextEditingController>> _controllers = [];

  void addRow(Map<String, TextEditingController> map) {
    _controllers.add(map);
  }

  Map<String, TextEditingController> getByRow(int row) {
    return _controllers[row];
  }

  get controllers {
    return _controllers;
  }
}

class _CWDynamicRow extends StatefulWidget {
  final List<CWTextField> children;

  const _CWDynamicRow({Key key, this.children}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CWDynamicRowState();
}

class _CWDynamicRowState extends State<_CWDynamicRow> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      clipBehavior: Clip.hardEdge,
      children: widget.children,
    );
  }
}
