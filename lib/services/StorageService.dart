import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_planner/models/Settings.dart';
import 'package:study_planner/models/StudyPlan.dart';

class StorageService {
  static const _STUDY_PLAN = 'studyplan-v0.1';
  static const _SETTINGS = 'settings-v0.1';

  SharedPreferences prefs;

  StorageService() {
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  StudyPlan loadStudyPlan() {
    var jsonString = prefs.get(_STUDY_PLAN);
    if (jsonString == null) {
      return StudyPlan();
    }
    var jsonObj = json.decode(jsonString);
    var plan = StudyPlan.fromJson(jsonObj);
    print('Reading: ${plan.toJson()}');
    return plan;
  }

  Future<void> saveStudyPlan(StudyPlan plan) async {
    print('Saving: ${plan.toJson()}');
    await prefs.setString(_STUDY_PLAN, jsonEncode(plan.toJson()));
  }

  Settings loadSettings() {
    var jsonString = prefs.get(_SETTINGS);
    if (jsonString == null) {
      return Settings();
    }
    var jsonObj = json.decode(jsonString);
    var settings = Settings.fromJson(jsonObj);
    print('Reading: ${settings.toJson()}');
    return settings;
  }

  Future<void> saveSettings(Settings settings) async {
    await prefs.setString(_SETTINGS, jsonEncode(settings.toJson()));
  }
}
