import 'package:flutter/material.dart';
import '../pages/LoadingScreen.page.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Type currentType = LoadingScreen;

  Future<dynamic> navigateTo(Widget page, {bool force = true}) async {
    if (force || currentType != page.runtimeType) {
      currentType = page.runtimeType;
      return navigatorKey.currentState?.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) => page,
          transitionDuration: Duration.zero,
        ),
      );
    }
    return;
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }
}
