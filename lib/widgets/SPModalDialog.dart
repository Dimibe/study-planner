import 'dart:math';

import 'package:flutter/material.dart';

class SPModalDialog extends StatelessWidget {
  final Widget title;
  final dynamic content;
  final dynamic actions;

  const SPModalDialog({Key key, this.title, this.content, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = 10.0;
        print(constraints.maxWidth);
        if (constraints.maxWidth > 450) {
          padding = 30.0;
        }
        var minWidth = min(constraints.maxWidth - 2 * padding, 700);

        return AlertDialog(
          insetPadding: EdgeInsets.all(padding),
          actionsPadding: EdgeInsets.only(
            left: padding / 2,
            right: padding / 2,
            bottom: padding / 2,
          ),
          contentPadding:
              EdgeInsets.only(left: padding / 2, right: padding / 2),
          buttonPadding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          title: title,
          content: Container(
            padding: EdgeInsets.all(padding),
            constraints: BoxConstraints(minWidth: minWidth, maxWidth: 700),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content is List ? content : content(constraints),
              ),
            ),
          ),
          actions: actions is List ? actions : actions(constraints),
        );
      },
    );
  }
}
