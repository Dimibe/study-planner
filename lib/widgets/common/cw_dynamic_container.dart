import 'package:flutter/material.dart';
import './cw_base_widget.dart';

class CWDynamicContainer extends StatefulWidget {
  final bool? showHideOption;
  final bool? showAddOption;
  final CWDynamicController contoller;
  final List<CWBaseWidget> children;
  final List<Map<String, dynamic>>? Function() initialData;
  final EdgeInsets padding;

  const CWDynamicContainer({
    super.key,
    this.showHideOption,
    this.showAddOption,
    required this.contoller,
    required this.children,
    required this.initialData,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<StatefulWidget> createState() => _CWDynamicContainerState();

  static _CWDynamicContainerState? _of(BuildContext context) {
    return context.findAncestorStateOfType<_CWDynamicContainerState>();
  }
}

class _CWDynamicContainerState extends State<CWDynamicContainer> {
  List<_CWDynamicRow> rows = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialData() != null) {
      widget.initialData()!.forEach(addRow);
    } else {
      addEmptyRow();
    }
  }

  void addRow([Map<String, dynamic>? rowValues]) {
    var map = <String, dynamic>{};

    var widgets = <Widget>[];

    for (var baseWidget in widget.children) {
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

  void removeRow(_CWDynamicRow row) {
    widget.contoller.removeRow(rows.indexOf(row));
    setState(() {
      rows.remove(row);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...rows,
          Padding(
            padding: widget.padding,
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: addEmptyRow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CWDynamicController {
  final _controllers = <Map<String, dynamic>>[];

  void addRow(Map<String, dynamic> map) {
    _controllers.add(map);
  }

  void removeRow(int index) {
    _controllers.removeAt(index);
  }

  Map<String, dynamic> getByRow(int row) {
    return _controllers[row];
  }

  List<Map<String, dynamic>> get controllers {
    return _controllers;
  }
}

class _CWDynamicRow extends StatefulWidget {
  final List<Widget> children;

  const _CWDynamicRow({required this.children});

  @override
  State<StatefulWidget> createState() => _CWDynamicRowState();
}

class _CWDynamicRowState extends State<_CWDynamicRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Wrap(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          ...widget.children,
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 8.0),
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () =>
                    CWDynamicContainer._of(context)!.removeRow(widget),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
