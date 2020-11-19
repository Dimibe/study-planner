import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/services/FirestoreService.dart';
import 'package:study_planner/services/NavigatorService.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/utils/UserRouting.dart';

import '../main.dart';

final getIt = GetIt.instance;

class LoadingScreen extends StatefulWidget with UserRouting {
  final FlutterI18nDelegate flutterI18nDelegate;

  LoadingScreen(this.flutterI18nDelegate);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<dynamic> _initialized;

  @override
  void initState() {
    super.initState();
    _initialized = Future.wait([
      Firebase.initializeApp(),
      Future.delayed(Duration(seconds: 1)),
      widget.flutterI18nDelegate.load(null),
    ]);
    _initialized.then((value) {
      setupFirebase();
      MyApp.of(context).applyUserSettings(context);
      _handleLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Center(child: CircularProgressIndicator())),
    );
  }

  void setupFirebase() {
    getIt.registerSingleton<UserService>(UserService());
    getIt.registerSingleton<StorageService>(StorageService());
    getIt.registerSingleton<FirestoreService>(FirestoreService());
  }

  void _handleLoginStatus() async {
    var _page = await widget.getNextRoute();
    await getIt<NavigatorService>().navigateTo(_page, force: false);
  }
}
