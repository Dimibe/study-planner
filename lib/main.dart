import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';
import 'package:study_planner/services/FirestoreService.dart';
import 'package:study_planner/services/SettingsService.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/services/UserService.dart';
import 'services/StorageService.dart';

final getIt = GetIt.instance;

void main() async {
  await Firebase.initializeApp();
  setup();
  runApp(MyApp());
}

void setup() {
  getIt.registerSingleton<UserService>(UserService());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<FirestoreService>(FirestoreService());
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<StudyPlanService>(StudyPlanService());
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

  @override
  void initState() {
    super.initState();
    getIt<UserService>().addAuthStateListener((user) => setPrimarySwatch());
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
      home: GeneralInformationPage(),
    );
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
