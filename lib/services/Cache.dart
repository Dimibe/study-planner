import 'package:study_planner/models/Settings.dart';
import 'package:study_planner/models/StudyPlan.dart';

class Cache {
  StudyPlan _studyPlan;
  Settings _settings;

  Cache();

  StudyPlan get studyPlan => _studyPlan;
  set studyPlan(var studyplan) => _studyPlan = studyPlan;
  Settings get settings => _settings;
  set settings(var settings) => _settings = settings;

  void reset() {
    _studyPlan = null;
    _settings = null;
  }
}
