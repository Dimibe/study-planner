import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:study_planner/models/Settings.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/widgets/SPDrawer.dart';
import 'package:study_planner/widgets/common/CWButton.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings settings;
  int themeColorIndex = 0;

  @override
  void initState() {
    super.initState();
    StorageService.loadSettings().then((value) {
      if (value != null) {
        setState(() {
          settings = value;
          themeColorIndex = settings.themeColorIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Planner!'),
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: SPDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 4.0,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        radius: 70 / 2,
                        backgroundColor: Colors.primaries[themeColorIndex],
                      ),
                    ),
                  ),
                  CWButton(
                    label: 'Change Color',
                    color: Theme.of(context).buttonColor,
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    onPressed: _openFullMaterialColorPicker,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: Container(width: 400, height: 400, child: content),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                MyApp.of(context).setPrimarySwatch();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                settings.themeColorIndex = themeColorIndex;
                StorageService.saveSettings(settings);
                MyApp.of(context).setPrimarySwatch();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openFullMaterialColorPicker() async {
    _openDialog(
      "Full Material Color picker",
      MaterialColorPicker(
        allowShades: false,
        colors: Colors.primaries,
        circleSize: 150.0,
        selectedColor: settings?.themeColorIndex == null
            ? Colors.green
            : Colors.primaries[settings.themeColorIndex],
        onMainColorChange: (color) {
          setState(() {
            themeColorIndex = Colors.primaries.indexOf(color);
          });
          MyApp.of(context).setPrimarySwatch(color: color);
        },
      ),
    );
  }
}
