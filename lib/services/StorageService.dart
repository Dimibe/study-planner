import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_planner/models/StudyPlan.dart';

class StorageService {
  static const STUDY_PLAN = 'studyplan-v0.1';

  static Future<StudyPlan> loadStudyPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.get(STUDY_PLAN);
    var jsonObj = json.decode(jsonString);
    var plan = StudyPlan.fromJson(jsonObj);
    print('Reading: ${plan.toJson()}');
    return plan;
  }

  static void saveStudyPlan(StudyPlan plan) async {
    print('Saving: ${plan.toJson()}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(STUDY_PLAN, jsonEncode(plan.toJson()));
  }
}
