import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeHandler extends InheritedWidget {
  final ThemeData theme;

  ThemeHandler({@required this.theme, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(ThemeHandler oldWidget) {
    return oldWidget.theme != theme;
  }

  static ThemeHandler of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeHandler>();
  }
}
