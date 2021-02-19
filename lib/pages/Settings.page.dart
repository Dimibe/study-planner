import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/Settings.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/NavigatorService.dart';
import 'package:study_planner/services/SettingsService.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWAppState.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWDropDown.dart';
import 'package:study_planner/widgets/common/CWText.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';
import '../main.dart';

final getIt = GetIt.instance;

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends CWState<SettingsPage> {
  Settings settings;
  int themeColorIndex = 0;
  var textEditingController = TextEditingController();
  var dropDownController = DropDownController();

  @override
  void initState() {
    super.initState();
    getIt<SettingsService>().loadSettings().then((value) {
      if (value != null) {
        setState(() {
          settings = value;
          themeColorIndex = settings.themeColorIndex;
          dropDownController.value = settings.locale;
        });
      }
    });
    getIt<StudyPlanService>().loadStudyPlan().then((value) {
      setState(() {
        textEditingController.text = json.encode(value.toJson());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      header: 'header.settings',
      content: [
        CWDropDown<String>(
          labelText: 'label.selectLanguage',
          items: ['de', 'en'],
          maxWidth: 290,
          controller: dropDownController,
          onChanged: (var value) async {
            await FlutterI18n.refresh(context, Locale(value));
            setState(() {
              settings.locale = value;
            });
          },
        ),
        CWButton(
          label: 'button.label.saveLanguage',
          color: Theme.of(context).buttonColor,
          padding: EdgeInsets.all(8.0),
          onPressed: () {
            getIt<SettingsService>().saveSettings(settings);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 70 / 2,
            backgroundColor: Colors.primaries[themeColorIndex],
          ),
        ),
        CWButton(
          label: 'label.changeColor',
          color: Theme.of(context).buttonColor,
          padding: EdgeInsets.all(8.0),
          onPressed: _openFullMaterialColorPicker,
        ),
        CWTextField(
          labelText: 'label.studyplan',
          maxLines: 10,
          controller: textEditingController,
        ),
        CWButton(
          label: 'button.label.saveStudyplan',
          color: Theme.of(context).buttonColor,
          padding: EdgeInsets.all(8.0),
          onPressed: () => getIt<StudyPlanService>().saveStudyPlan(
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
          title: CWText(title),
          content: content,
          actions: [
            FlatButton(
              child: CWText('button.label.cancel'),
              onPressed: () {
                MyApp.of(context).applyUserSettings(context);
                getIt<NavigatorService>().pop();
              },
            ),
            CWButton(
              label: 'button.label.save',
              minWidth: 100,
              minHeight: 40,
              fontSize: 16,
              onPressed: () {
                settings.themeColorIndex = themeColorIndex;
                getIt<SettingsService>().saveSettings(settings);
                MyApp.of(context).applyUserSettings(context);
                getIt<NavigatorService>().pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openFullMaterialColorPicker() async {
    _openDialog(
      'text.colorSelection',
      MaterialColorPicker(
        allowShades: false,
        colors: Colors.primaries,
        selectedColor: settings?.themeColorIndex == null
            ? Colors.green
            : Colors.primaries[settings.themeColorIndex],
        onMainColorChange: (color) {
          setState(() {
            themeColorIndex = Colors.primaries.indexOf(color);
          });
          MyApp.of(context).applyUserSettings(context, color: color);
        },
      ),
    );
  }
}
