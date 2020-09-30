import 'package:flutter/material.dart';

import 'CWTextField.dart';

class CWDynamicRow extends StatelessWidget {
  final bool showHideOption;
  final bool showAddOption;
  final List<List<TextEditingController>> contoller;
  final List<CWTextField> children;

  const CWDynamicRow(
      {Key key,
      this.showHideOption,
      this.showAddOption,
      this.contoller,
      this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: this.children,
    );
  }
}
