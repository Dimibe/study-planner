import 'package:flutter/material.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';
import 'services/StorageService.dart';

void main() {
  runApp(MyApp());
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
  int themeColorIndex = 9;

  @override
  void initState() {
    super.initState();
    setPrimarySwatch();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.primaries[themeColorIndex],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GeneralInformationPage(),
    );
  }

  void setPrimarySwatch({ColorSwatch color}) {
    if (color != null) {
      setState(() {
        themeColorIndex = Colors.primaries.indexOf(color);
      });
    } else {
      StorageService.loadSettings().then((settings) {
        setState(() {
          themeColorIndex = settings.themeColorIndex;
        });
      });
    }
  }
}
