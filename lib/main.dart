import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_web.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'pages/Welcome.page.dart';
import 'services/NavigatorService.dart';
import 'utils/UserRouting.dart';
import 'services/Cache.dart';
import 'services/FirestoreService.dart';
import 'services/SettingsService.dart';
import 'services/StudyPlanService.dart';
import 'services/UserService.dart';
import 'services/StorageService.dart';

final getIt = GetIt.instance;

void main() async {
  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

void setup({bool initFirebase = true}) {
  if (initFirebase) {
    getIt.registerSingleton<UserService>(UserService());
    getIt.registerSingleton<StorageService>(StorageService());
    getIt.registerSingleton<FirestoreService>(FirestoreService());
  }
  getIt.registerSingleton<NavigatorService>(NavigatorService());
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<StudyPlanService>(StudyPlanService());
  getIt.registerSingleton<Cache>(Cache());
}

class MyApp extends StatefulWidget with UserRouting {
  const MyApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();

  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<State<MyApp>>();
  }
}

class MyAppState extends State<MyApp> {
  int _themeColorIndex = 17;
  StreamSubscription authStateListener;
  Widget _homeScreen = WelcomePage();

  @override
  void initState() {
    super.initState();
    authStateListener = getIt<UserService>().addAuthStateListener((user) {
      setPrimarySwatch();
      _handleLoginStatus();
    });
  }

  @override
  void dispose() {
    authStateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      navigatorKey: getIt<NavigatorService>().navigatorKey,
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: 'assets/i18n',
            fallbackFile: 'de',
            decodeStrategies: [YamlDecodeStrategy()],
          ),
          missingTranslationHandler: (key, locale) {
            print('Missing Key: $key, languageCode: ${locale.languageCode}');
          },
        ),
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.primaries[_themeColorIndex],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _homeScreen,
    );
  }

  void _handleLoginStatus() async {
    var _page = await widget.getNextRoute();
    getIt<NavigatorService>().navigateTo(_page, force: false);
  }

  /// This function can be called from outside to change the primarySwatch
  void setPrimarySwatch({ColorSwatch color}) {
    if (color != null) {
      setState(() {
        _themeColorIndex = Colors.primaries.indexOf(color);
      });
    } else {
      getIt<SettingsService>().loadSettings().then((settings) {
        setState(() {
          _themeColorIndex = settings.themeColorIndex;
        });
      });
    }
  }
}
