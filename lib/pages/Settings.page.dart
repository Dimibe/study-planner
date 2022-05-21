import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/settings.dart';
import 'package:study_planner/models/study_plan.dart';
import 'package:study_planner/services/navigator.service.dart';
import 'package:study_planner/services/settings.service.dart';
import 'package:study_planner/services/study_plan.service.dart';
import 'package:study_planner/widgets/sp_dialog.dart';
import 'package:study_planner/widgets/common/cw_app_state.dart';
import 'package:study_planner/widgets/common/cw_button.dart';
import 'package:study_planner/widgets/common/cw_dropdown.dart';
import 'package:study_planner/widgets/common/cw_text.dart';
import 'package:study_planner/widgets/common/cw_textfield.dart';
import '../main.dart';

final getIt = GetIt.instance;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends CWState<SettingsPage> {
  late final Settings settings;
  int themeColorIndex = 0;
  final textEditingController = TextEditingController();
  final dropDownController = DropDownController();

  @override
  void initState() {
    super.initState();
    getIt<SettingsService>().loadSettings().then((value) {
      setState(() {
        settings = value;
        themeColorIndex = settings.themeColorIndex;
        dropDownController.value = settings.locale;
      });
    });
    getIt<StudyPlanService>().loadStudyPlan().then((value) {
      setState(() {
        textEditingController.text = json.encode(value?.toJson());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      header: 'header.settings',
      content: [
        CWDropDown<String>(
          id: 'language-select',
          labelText: 'label.selectLanguage',
          items: const ['de', 'en'],
          maxWidth: 290,
          controller: dropDownController,
          onChanged: (var value) async {
            await FlutterI18n.refresh(context, Locale(value!));
            setState(() {
              settings.locale = value;
            });
          },
        ),
        CWButton(
          label: 'button.label.saveLanguage',
          color: Theme.of(context).buttonColor,
          padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8.0),
          onPressed: _openFullMaterialColorPicker,
        ),
        CWTextField(
          id: 'studyplan',
          labelText: 'label.studyplan',
          maxLines: 10,
          controller: textEditingController,
        ),
        CWButton(
          label: 'button.label.saveStudyplan',
          color: Theme.of(context).buttonColor,
          padding: const EdgeInsets.all(8.0),
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
            TextButton(
              onPressed: () {
                MyApp.of(context)?.applyUserSettings(context);
                getIt<NavigatorService>().pop();
              },
              child: const CWText('button.label.cancel'),
            ),
            CWButton(
              label: 'button.label.save',
              minWidth: 100,
              minHeight: 40,
              fontSize: 16,
              onPressed: () {
                settings.themeColorIndex = themeColorIndex;
                getIt<SettingsService>().saveSettings(settings);
                MyApp.of(context)?.applyUserSettings(context);
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
        selectedColor: Colors.primaries[settings.themeColorIndex],
        onMainColorChange: (color) {
          setState(() {
            themeColorIndex = Colors.primaries.indexOf(color as MaterialColor);
          });
          MyApp.of(context)?.applyUserSettings(context, color: color);
        },
      ),
    );
  }
}
