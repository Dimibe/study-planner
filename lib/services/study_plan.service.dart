import 'package:get_it/get_it.dart';

import '../models/study_plan.dart';
import '../services/firestore.service.dart';
import 'cache.service.dart';
import './user.service.dart';

final getIt = GetIt.instance;

class StudyPlanService {
  StudyPlanService();

  Future<StudyPlan?> loadStudyPlan({force = false}) async {
    var studyPlan = getIt<Cache>().studyPlan;
    if (!force && studyPlan != null) {
      return studyPlan;
    }
    if (getIt<UserService>().isLoggedIn) {
      var uid = getIt<UserService>().getUid()!;
      var document = getIt<FirestoreService>().getDocument('studyplans', uid);
      var json = (await document).data() as Map<String, dynamic>?;
      studyPlan = StudyPlan.fromJson(json ?? {});
    }
    print('Reading settings: ${studyPlan?.toJson()}');
    getIt<Cache>().studyPlan = studyPlan;
    return studyPlan;
  }

  Future<void> saveStudyPlan(StudyPlan studyPlan) async {
    print('Saving: ${studyPlan.toJson()}');
    getIt<Cache>().studyPlan = studyPlan;
    if (getIt<UserService>().isLoggedIn) {
      var uid = getIt<UserService>().getUid()!;
      return getIt<FirestoreService>()
          .saveDocument('studyplans', uid, studyPlan.toJson());
    }
    return;
  }
}
