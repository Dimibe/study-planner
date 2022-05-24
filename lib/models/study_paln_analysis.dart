import 'dart:math';

import '../utils/study_plan_utils.dart';
import 'semester.dart';
import 'study_plan.dart';

class StudyPlanAnalysis {
  late List<Semester> semester;
  late int creditsTotal;
  late int creditsNow;
  late int creditsOpen;
  late double meanCreditsSemster;
  late double semesterOpen;
  late int semesterCount;
  late int openSemester;
  late int creditsInMainPlan;

  late int plannedCreditsNow;
  late int plannedCreditsOpen;
  late double plannedMeanCreditsSemster;
  late double plannedSemesterOpen;
  late int plannedSemesterCount;
  late int plannedOpenSemester;
  late double plannedCreditsPerSemester;
  late int plannedCreditsInMainPlan;

  double? meanGrade;

  late String bestPossibleGrade;
  late String plannedBestPossibleGrade;

  StudyPlanAnalysis(StudyPlan studyPlan) {
    init(studyPlan);
  }

  void init(StudyPlan studyPlan) {
    semester = studyPlan.semester;
    creditsTotal = studyPlan.creditsMain + (studyPlan.creditsOther ?? 0);
    creditsNow = StudyPlanUtils.sumOfCredits(studyPlan, onlyCompleted: false);
    creditsOpen = creditsTotal - creditsNow;
    semesterCount = studyPlan.semester.length;
    meanCreditsSemster = creditsNow / semesterCount;
    semesterOpen = max(creditsOpen / meanCreditsSemster, 0);
    openSemester = studyPlan.semesterCount - semesterCount;

    plannedCreditsNow =
        StudyPlanUtils.sumOfCredits(studyPlan, onlyCompleted: true);
    plannedSemesterCount =
        studyPlan.semester.where((element) => element.completed).length;
    plannedCreditsOpen = creditsTotal - plannedCreditsNow;
    plannedMeanCreditsSemster = plannedSemesterCount == 0
        ? 0
        : (plannedCreditsNow / plannedSemesterCount);
    plannedSemesterOpen =
        max(plannedCreditsOpen / plannedMeanCreditsSemster, 0);
    if (plannedSemesterOpen == double.infinity) {}
    plannedOpenSemester = studyPlan.semesterCount - plannedSemesterCount;
    plannedCreditsPerSemester = plannedOpenSemester == 0
        ? 0
        : max(plannedCreditsOpen / plannedOpenSemester, 0);

    meanGrade = StudyPlanUtils.totalMeanGrade(
      studyPlan,
      onlyCompleted: true,
    );

    creditsInMainPlan = StudyPlanUtils.sumOfCredits(studyPlan,
        onlyCompleted: true, fieldName: 'Hauptstudium');
    plannedCreditsInMainPlan =
        StudyPlanUtils.sumOfCredits(studyPlan, fieldName: 'Hauptstudium');

    bestPossibleGrade = StudyPlanUtils.bestPossibleMeanGrade(
      studyPlan,
      onlyCompleted: true,
    ).toStringAsFixed(2);

    plannedBestPossibleGrade =
        StudyPlanUtils.bestPossibleMeanGrade(studyPlan).toStringAsFixed(2);
  }
}
