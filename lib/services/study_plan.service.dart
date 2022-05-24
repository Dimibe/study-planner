import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'cache.service.dart';
import 'user.service.dart';
import '../models/study_plan.dart';
import '../services/firestore.service.dart';

final getIt = GetIt.instance;
final logger = Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));

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
    logger.i('Reading settings: ${studyPlan?.toJson()}');
    getIt<Cache>().studyPlan = studyPlan;
    return studyPlan;
  }

  Future<void> saveStudyPlan(StudyPlan studyPlan) async {
    logger.i('Saving: ${studyPlan.toJson()}');
    getIt<Cache>().studyPlan = studyPlan;
    if (getIt<UserService>().isLoggedIn) {
      var uid = getIt<UserService>().getUid()!;
      return getIt<FirestoreService>()
          .saveDocument('studyplans', uid, studyPlan.toJson());
    }
    return;
  }
}
