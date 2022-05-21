import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';
import '../models/study_plan.dart';

class StorageService {
  static const studyPlanKey = 'studyplan-v0.1';
  static const settingsKey = 'settings-v0.1';

  late final SharedPreferences prefs;

  StorageService() {
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  StudyPlan loadStudyPlan() {
    var jsonString = prefs.get(studyPlanKey) as String?;
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
    await prefs.setString(studyPlanKey, jsonEncode(plan.toJson()));
  }

  Settings loadSettings() {
    var jsonString = prefs.get(settingsKey) as String?;
    if (jsonString == null) {
      return Settings();
    }
    var jsonObj = json.decode(jsonString);
    var settings = Settings.fromJson(jsonObj);
    print('Reading: ${settings.toJson()}');
    return settings;
  }

  Future<void> saveSettings(Settings settings) async {
    await prefs.setString(settingsKey, jsonEncode(settings.toJson()));
  }
}
