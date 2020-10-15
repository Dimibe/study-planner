import 'package:flutter/material.dart';
import 'package:study_planner/pages/Welcome.page.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Type currentType = WelcomePage;

  Future<dynamic> navigateTo(Widget page) {
    print(currentType.toString());
    if (currentType != page.runtimeType) {
      currentType = page.runtimeType;
      return navigatorKey.currentState
          .pushReplacement(MaterialPageRoute(builder: (context) => page));
    }
    return null;
  }

  void pop() {
    navigatorKey.currentState.pop();
  }
}
