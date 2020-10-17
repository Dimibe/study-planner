import 'package:flutter/material.dart';
import 'package:study_planner/widgets/common/CWBase.dart';

class CWDynamicContainer extends StatefulWidget {
  final bool showHideOption;
  final bool showAddOption;
  final CWDynamicController contoller;
  final List<CWBase> children;
  final List<Map<String, dynamic>> Function() initialData;
  final EdgeInsets padding;

  const CWDynamicContainer({
    Key key,
    this.showHideOption,
    this.showAddOption,
    this.contoller,
    this.children,
    this.initialData,
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
    if (widget.initialData() != null) {
      widget.initialData().forEach((rowValues) => addRow(rowValues));
    } else {
      addEmptyRow();
    }
  }

  void addRow([Map<String, dynamic> rowValues]) {
    Map<String, dynamic> map = {};

    var widgets = <Widget>[];

    for (CWBase baseWidget in widget.children) {
      var controller = baseWidget.createController();
      if (rowValues != null && rowValues[baseWidget.id] != null) {
        controller.text = '${rowValues[baseWidget.id]}';
      }
      map.putIfAbsent(baseWidget.id, () => controller);
      var copy = baseWidget.copy(controller);
      widgets.add(copy);
    }

    widget.contoller.addRow(map);
    setState(() => rows.add(_CWDynamicRow(children: widgets)));
  }

  void addEmptyRow() {
    addRow();
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
  List<Map<String, dynamic>> _controllers = [];

  void addRow(Map<String, dynamic> map) {
    _controllers.add(map);
  }

  Map<String, dynamic> getByRow(int row) {
    return _controllers[row];
  }

  get controllers {
    return _controllers;
  }
}

class _CWDynamicRow extends StatefulWidget {
  final List<Widget> children;

  const _CWDynamicRow({Key key, this.children}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CWDynamicRowState();
}

class _CWDynamicRowState extends State<_CWDynamicRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Wrap(
        clipBehavior: Clip.hardEdge,
        children: widget.children,
      ),
    );
  }
}
