import 'package:flutter/material.dart';

import 'CWTextField.dart';

class CWDynamicRow extends StatefulWidget {
  final bool showHideOption;
  final bool showAddOption;
  final List<List<TextEditingController>> contoller;
  final List<CWTextField> children;
  final EdgeInsets padding;

  const CWDynamicRow({
    Key key,
    this.showHideOption,
    this.showAddOption,
    this.contoller,
    this.children,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CWDynamicRowState();
}

class _CWDynamicRowState extends State<CWDynamicRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: ListView(
        shrinkWrap: true,
        children: [
          Wrap(
            clipBehavior: Clip.hardEdge,
            children: widget.children,
          ),
          Container(
            width: 50,
            height: 50,
            color: Theme.of(context).accentColor,
            child: IconButton(
              icon: Icon(
                Icons.add,
                //color: Theme.of(context).indicatorColor,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
