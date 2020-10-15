import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/AnalysisOverview.page.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';
import 'package:study_planner/pages/SemesterOverview.page.dart';
import 'package:study_planner/pages/Welcome.page.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/services/UserService.dart';

final GetIt getIt = GetIt.instance;

mixin UserRouting {
  Future<Widget> getNextRoute() async {
    var page;
    if (getIt<UserService>().isLoggedIn) {
      var plan = await getIt<StudyPlanService>().loadStudyPlan();
      if (plan.semester.isNotEmpty) {
        page = AnalysisOverviewPage();
      } else if (plan.uni != null) {
        page = SemesterOverviewPage();
      } else {
        page = GeneralInformationPage();
      }
    } else {
      page = WelcomePage();
    }
    return page;
  }
}
