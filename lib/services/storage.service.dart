import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';
import '../models/study_plan.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));

class StorageService {
  static const studyPlanKey = 'studyplan-v0.1';
  static const settingsKey = 'settings-v0.1';

  late final SharedPreferences prefs;

  StorageService() {
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  StudyPlan? loadStudyPlan() {
    var jsonString = prefs.get(studyPlanKey) as String?;
    if (jsonString == null) {
      return null;
    }
    var jsonObj = json.decode(jsonString);
    var plan = StudyPlan.fromJson(jsonObj);
    logger.i('Reading: ${plan.toJson()}');
    return plan;
  }

  Future<void> saveStudyPlan(StudyPlan plan) async {
    logger.i('Saving: ${plan.toJson()}');
    await prefs.setString(studyPlanKey, jsonEncode(plan.toJson()));
  }

  Settings loadSettings() {
    var jsonString = prefs.get(settingsKey) as String?;
    if (jsonString == null) {
      return Settings();
    }
    var jsonObj = json.decode(jsonString);
    var settings = Settings.fromJson(jsonObj);
    logger.i('Reading: ${settings.toJson()}');
    return settings;
  }

  Future<void> saveSettings(Settings settings) async {
    await prefs.setString(settingsKey, jsonEncode(settings.toJson()));
  }
}
