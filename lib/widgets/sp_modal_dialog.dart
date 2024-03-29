import 'dart:math';

import 'package:flutter/material.dart';

import 'sp_form.dart';
import 'common/cw_text.dart';

/// Base Widget which should be returned by any modal page widget.
class SPModalDialog extends StatefulWidget {
  final String? title;
  final dynamic content;
  final dynamic actions;
  final double? minWidth;
  final double? maxWidth;
  final double? padding;

  const SPModalDialog({
    super.key,
    required this.content,
    required this.actions,
    this.title,
    this.minWidth,
    this.maxWidth,
    this.padding,
  });

  @override
  State<SPModalDialog> createState() => _SPModalDialogState();
}

class _SPModalDialogState extends State<SPModalDialog> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = 10.0;
        if (constraints.maxWidth > 450) {
          padding = widget.padding ?? 30.0;
        }

        var minWidth =
            widget.minWidth ?? min(constraints.maxWidth - 2 * padding, 700);

        return Container(
          constraints: BoxConstraints(
              minWidth: minWidth, maxWidth: widget.maxWidth ?? 700),
          child: AlertDialog(
            elevation: 0.0,
            insetPadding: EdgeInsets.all(padding),
            contentPadding:
                EdgeInsets.only(left: padding / 2, right: padding / 2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            title: widget.title == null ? Container() : CWText(widget.title!),
            content: Container(
              padding: EdgeInsets.all(padding),
              constraints: BoxConstraints(
                  minWidth: minWidth, maxWidth: widget.maxWidth ?? 700),
              child: SingleChildScrollView(
                child: SPForm(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.content is List) ...widget.content,
                      if (widget.content is! List)
                        ...widget.content(constraints),
                      const Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: (widget.actions is List
                            ? widget.actions as List<Widget>
                            : widget.actions(constraints)) as List<Widget>,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
