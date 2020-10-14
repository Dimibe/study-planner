import 'package:get_it/get_it.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/FirestoreService.dart';

import 'UserService.dart';
import 'StorageService.dart';

class StudyPlanService {
  StudyPlanService();

  Future<StudyPlan> loadStudyPlan() async {
    if (GetIt.I<UserService>().isLoggedIn) {
      var uid = GetIt.I<UserService>().getUid();
      var document = GetIt.I<FirestoreService>().getDocument('studyplans', uid);
      var json = (await document).data();
      if (json == null) {
        return StudyPlan();
      }
      return StudyPlan.fromJson(json);
    } else {
      return GetIt.I<StorageService>().loadStudyPlan();
    }
  }

  Future<void> saveStudyPlan(StudyPlan studyPlan) async {
    if (GetIt.I<UserService>().isLoggedIn) {
      var uid = GetIt.I<UserService>().getUid();
      return GetIt.I<FirestoreService>()
          .saveDocument('studyplans', uid, studyPlan.toJson());
    } else {
      return GetIt.I<StorageService>().saveStudyPlan(studyPlan);
    }
  }
}
