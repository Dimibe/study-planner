import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../pages/analysis_overview.page.dart';
import '../pages/general_information.page.dart';
import '../pages/semester_overview.page.dart';
import '../pages/welcome.page.dart';
import '../services/study_plan.service.dart';
import '../services/user.service.dart';

final GetIt getIt = GetIt.instance;

mixin UserRouting {
  Future<Widget> getNextRoute() async {
    StatefulWidget page;
    if (getIt<UserService>().isLoggedIn) {
      var plan = await getIt<StudyPlanService>().loadStudyPlan();
      if (plan == null) {
        page = const GeneralInformationPage();
      } else if (plan.semester.isNotEmpty) {
        page = const AnalysisOverviewPage();
      } else {
        page = const SemesterOverviewPage();
      }
    } else {
      page = const WelcomePage();
    }
    return page;
  }
}
