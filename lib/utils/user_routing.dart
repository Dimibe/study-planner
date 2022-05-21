import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/analysis_overview.page.dart';
import 'package:study_planner/pages/general_information.page.dart';
import 'package:study_planner/pages/semester_overview.page.dart';
import 'package:study_planner/pages/welcome.page.dart';
import 'package:study_planner/services/study_plan.service.dart';
import 'package:study_planner/services/user.service.dart';

final GetIt getIt = GetIt.instance;

mixin UserRouting {
  Future<Widget> getNextRoute() async {
    StatefulWidget page;
    if (getIt<UserService>().isLoggedIn) {
      var plan = await getIt<StudyPlanService>().loadStudyPlan();
      if (plan!.semester.isNotEmpty) {
        page = const AnalysisOverviewPage();
      } else if (plan.uni != null) {
        page = const SemesterOverviewPage();
      } else {
        page = const GeneralInformationPage();
      }
    } else {
      page = const WelcomePage();
    }
    return page;
  }
}
