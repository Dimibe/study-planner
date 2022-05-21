import 'package:flutter/material.dart';

class ThemeHandler extends InheritedWidget {
  final ThemeData theme;

  const ThemeHandler({super.key, required this.theme, required super.child});

  @override
  bool updateShouldNotify(ThemeHandler oldWidget) {
    return oldWidget.theme != theme;
  }

  static ThemeHandler? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeHandler>();
  }
}
