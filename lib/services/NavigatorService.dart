import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(Widget page) {
    return navigatorKey.currentState
        .pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  void pop() {
    navigatorKey.currentState.pop();
  }
}
