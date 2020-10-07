import 'package:flutter/material.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';

import 'services/StorageService.dart';
import 'models/Settings.dart';

void main() async {
  Settings settings = await StorageService.loadSettings();
  runApp(MyApp(themeColorIndex: settings?.themeColorIndex));
}

class MyApp extends StatefulWidget {
  final int themeColorIndex;

  const MyApp({Key key, this.themeColorIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: widget.themeColorIndex != null
            ? Colors.primaries[widget.themeColorIndex]
            : Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GeneralInformationPage(),
    );
  }
}
