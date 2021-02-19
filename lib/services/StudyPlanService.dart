import 'package:get_it/get_it.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/FirestoreService.dart';

import 'Cache.dart';
import 'UserService.dart';

final getIt = GetIt.instance;

class StudyPlanService {
  StudyPlanService();

  Future<StudyPlan> loadStudyPlan({force = false}) async {
    var studyPlan = getIt<Cache>().studyPlan;
    if (!force && studyPlan != null) {
      return studyPlan;
    }
    if (getIt<UserService>().isLoggedIn) {
      var uid = getIt<UserService>().getUid();
      var document = getIt<FirestoreService>().getDocument('studyplans', uid);
      var json = (await document).data();
      studyPlan = StudyPlan.fromJson(json ?? {});
    }
    print('Reading settings: ${studyPlan.toJson()}');
    getIt<Cache>().studyPlan = studyPlan;
    return studyPlan;
  }

  Future<void> saveStudyPlan(StudyPlan studyPlan) async {
    print('Saving: ${studyPlan.toJson()}');
    getIt<Cache>().studyPlan = studyPlan;
    if (getIt<UserService>().isLoggedIn) {
      var uid = getIt<UserService>().getUid();
      return getIt<FirestoreService>()
          .saveDocument('studyplans', uid, studyPlan.toJson());
    }
    return null;
  }
}
