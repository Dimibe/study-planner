import 'package:flutter/material.dart';
import 'package:study_planner/pages/Welcome.page.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Type currentType = WelcomePage;

  Future<dynamic> navigateTo(Widget page, {bool force = true}) {
    if (force || currentType != page.runtimeType) {
      currentType = page.runtimeType;
      return navigatorKey.currentState.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) => page,
          transitionDuration: Duration.zero,
        ),
      );
    }
    return null;
  }

  void pop() {
    navigatorKey.currentState.pop();
  }
}
