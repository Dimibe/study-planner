import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/Settings.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/SettingsService.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings settings;
  int themeColorIndex = 0;
  var textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    GetIt.I<SettingsService>().loadSettings().then((value) {
      if (value != null) {
        setState(() {
          settings = value;
          themeColorIndex = settings.themeColorIndex;
        });
      }
    });
    GetIt.I<StudyPlanService>().loadStudyPlan().then((value) {
      setState(() {
        textEditingController.text = json.encode(value.toJson());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      title: 'Study Planner!',
      content: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 70 / 2,
            backgroundColor: Colors.primaries[themeColorIndex],
          ),
        ),
        CWButton(
          label: 'Farbe ändern',
          color: Theme.of(context).buttonColor,
          padding: EdgeInsets.all(8.0),
          onPressed: _openFullMaterialColorPicker,
        ),
        CWTextField(
          labelText: 'Studienplan',
          maxLines: 5,
          controller: textEditingController,
        ),
        CWButton(
          label: 'Studienplan übernehmen',
          color: Theme.of(context).buttonColor,
          padding: EdgeInsets.all(8.0),
          onPressed: () => GetIt.I<StudyPlanService>().saveStudyPlan(
            StudyPlan.fromJson(json.decode(textEditingController.text)),
          ),
        ),
      ],
    );
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('Abbrechen'),
              onPressed: () {
                MyApp.of(context).setPrimarySwatch();
                Navigator.of(context).pop();
              },
            ),
            CWButton(
              label: 'Speichern',
              minWidth: 100,
              minHeight: 40,
              fontSize: 16,
              onPressed: () {
                settings.themeColorIndex = themeColorIndex;
                GetIt.I<SettingsService>().saveSettings(settings);
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
      'Farbauswahl',
      MaterialColorPicker(
        allowShades: false,
        colors: Colors.primaries,
        // circleSize: 150.0,
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
