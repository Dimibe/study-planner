import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'pages/loading_screen.page.dart';
import 'utils/user_routing.dart';
import 'widgets/theme_handler.dart';
import 'services/navigator.service.dart';
import 'services/cache.service.dart';
import 'services/settings.service.dart';
import 'services/study_plan.service.dart';

final getIt = GetIt.instance;
final logger = Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));

void main() async {
  setup();
  var flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      basePath: 'assets/i18n',
      fallbackFile: 'de',
      decodeStrategies: [YamlDecodeStrategy()],
    ),
    missingTranslationHandler: (key, locale) {
      logger.i('Missing Key: $key, languageCode: ${locale?.languageCode}');
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

  const MyApp(this.flutterI18nDelegate, {super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();

  static MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>();
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
        fontFamily: 'Roboto',
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
          theme: ThemeHandler.of(context)?.theme,
          home: LoadingScreen(widget.flutterI18nDelegate),
        ),
      ),
    );
  }

  /// This function can be called from outside to change the user settings
  void applyUserSettings(BuildContext context, {ColorSwatch? color}) {
    if (color != null) {
      setState(() {
        _themeColorIndex = Colors.primaries.indexOf(color as MaterialColor);
      });
    } else {
      getIt<SettingsService>().loadSettings().then((settings) {
        FlutterI18n.refresh(
          context,
          Locale(settings.locale),
        );

        setState(() {
          _themeColorIndex = settings.themeColorIndex;
        });
      });
    }
  }
}
