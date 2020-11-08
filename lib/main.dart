import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/LoadingScreen.page.dart';
import 'package:study_planner/utils/UserRouting.dart';
import 'package:study_planner/widgets/ThemeHandler.dart';

import 'services/NavigatorService.dart';
import 'services/Cache.dart';
import 'services/FirestoreService.dart';
import 'services/SettingsService.dart';
import 'services/StudyPlanService.dart';
import 'services/UserService.dart';
import 'services/StorageService.dart';

final getIt = GetIt.instance;

void main() async {
  setup();
  var flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      basePath: 'assets/i18n',
      fallbackFile: 'de',
      decodeStrategies: [YamlDecodeStrategy()],
    ),
    missingTranslationHandler: (key, locale) {
      print('Missing Key: $key, languageCode: ${locale.languageCode}');
    },
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(flutterI18nDelegate));
}

void setup() {
  getIt.registerSingleton<NavigatorService>(NavigatorService());
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<StudyPlanService>(StudyPlanService());
  getIt.registerSingleton<Cache>(Cache());
}

class MyApp extends StatefulWidget with UserRouting {
  final FlutterI18nDelegate flutterI18nDelegate;

  const MyApp(this.flutterI18nDelegate, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();

  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<State<MyApp>>();
  }
}

class MyAppState extends State<MyApp> {
  int _themeColorIndex = 17;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeHandler(
      theme: ThemeData(
        primarySwatch: Colors.primaries[_themeColorIndex],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Study Planner',
          debugShowCheckedModeBanner: false,
          navigatorKey: getIt<NavigatorService>().navigatorKey,
          localizationsDelegates: [
            widget.flutterI18nDelegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeHandler.of(context).theme,
          home: LoadingScreen(widget.flutterI18nDelegate),
        ),
      ),
    );
  }

  /// This function can be called from outside to change the user settings
  void applyUserSettings(BuildContext context, {ColorSwatch color}) {
    if (color != null) {
      setState(() {
        _themeColorIndex = Colors.primaries.indexOf(color);
      });
    } else {
      getIt<SettingsService>().loadSettings().then((settings) {
        if (settings.locale != null) {
          FlutterI18n.refresh(
            context,
            Locale(settings.locale),
          );
        }
        setState(() {
          _themeColorIndex = settings.themeColorIndex;
        });
      });
    }
  }
}
