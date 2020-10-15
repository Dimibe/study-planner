import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/Welcome.page.dart';

import 'pages/AnalysisOverview.page.dart';
import 'pages/GeneralInformation.page.dart';
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
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<StudyPlanService>(StudyPlanService());
  getIt.registerSingleton<Cache>(Cache());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();

  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<State<MyApp>>();
  }
}

class MyAppState extends State<MyApp> {
  int _themeColorIndex = 9;
  Widget _homeScreen = WelcomePage();
  StreamSubscription authStateListener;

  @override
  void initState() {
    super.initState();
    authStateListener = getIt<UserService>().addAuthStateListener((user) {
      setPrimarySwatch();
      setHomeScreen();
    });
  }

  @override
  void dispose() async {
    authStateListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.primaries[_themeColorIndex],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _homeScreen,
    );
  }

  void setHomeScreen() async {
    if (getIt<UserService>().isLoggedIn) {
      if (_homeScreen is! AnalysisOverviewPage) {
        var plan = await getIt<StudyPlanService>().loadStudyPlan();
        if (plan.semester.isNotEmpty) {
          setState(() {
            _homeScreen = AnalysisOverviewPage();
          });
        } else if (plan.uni != null) {
          setState(() {
            _homeScreen = AnalysisOverviewPage();
          });
        } else {
          _homeScreen = GeneralInformationPage();
        }
      }
    } else {
      if (_homeScreen is! WelcomePage) {
        setState(() {
          _homeScreen = WelcomePage();
        });
      }
    }
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
