import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:get_it/get_it.dart';

import '../services/firestore.service.dart';
import '../services/navigator.service.dart';
import '../services/storage.service.dart';
import '../services/user.service.dart';
import '../utils/user_routing.dart';

import '../main.dart';

final getIt = GetIt.instance;

class LoadingScreen extends StatefulWidget with UserRouting {
  final FlutterI18nDelegate flutterI18nDelegate;

  LoadingScreen(this.flutterI18nDelegate, {super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late final Future<dynamic> _initialized;

  @override
  void initState() {
    super.initState();
    _initialized = Future.wait([
      Firebase.initializeApp(),
      Future.delayed(const Duration(seconds: 1)),
      widget.flutterI18nDelegate.load(const Locale('de')),
    ]);
    _initialized.then((value) {
      setupFirebase();
      MyApp.of(context)?.applyUserSettings(context);
      _handleLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void setupFirebase() {
    getIt.registerSingleton<UserService>(UserService());
    getIt.registerSingleton<StorageService>(StorageService());
    getIt.registerSingleton<FirestoreService>(FirestoreService());
  }

  void _handleLoginStatus() async {
    var page = await widget.getNextRoute();
    await getIt<NavigatorService>().navigateTo(page, force: false);
  }
}
