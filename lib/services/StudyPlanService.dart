import 'package:get_it/get_it.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/FirestoreService.dart';

import 'UserService.dart';
import 'StorageService.dart';

class StudyPlanService {
  ///Cache entity to avoid long loading time.
  StudyPlan _studyPlan;

  StudyPlanService();

  Future<StudyPlan> loadStudyPlan({force = false}) async {
    if (!force && _studyPlan != null) {
      return _studyPlan;
    }
    StudyPlan studyPlan;
    if (GetIt.I<UserService>().isLoggedIn) {
      var uid = GetIt.I<UserService>().getUid();
      var document = GetIt.I<FirestoreService>().getDocument('studyplans', uid);
      var json = (await document).data();
      if (json == null) {
        studyPlan = StudyPlan();
      }
      studyPlan = StudyPlan.fromJson(json);
    } else {
      studyPlan = GetIt.I<StorageService>().loadStudyPlan();
    }

    return studyPlan;
  }

  Future<void> saveStudyPlan(StudyPlan studyPlan) async {
    _studyPlan = studyPlan;
    if (GetIt.I<UserService>().isLoggedIn) {
      var uid = GetIt.I<UserService>().getUid();
      return GetIt.I<FirestoreService>()
          .saveDocument('studyplans', uid, studyPlan.toJson());
    } else {
      return GetIt.I<StorageService>().saveStudyPlan(studyPlan);
    }
  }
}
