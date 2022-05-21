import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/semester.dart';
import 'package:study_planner/models/study_plan.dart';
import 'package:study_planner/pages/general_information.page.dart';
import 'package:study_planner/services/navigator.service.dart';
import 'package:study_planner/services/study_plan.service.dart';
import 'package:study_planner/utils/study_plan_utils.dart';
import 'package:study_planner/widgets/sp_barchart.dart';
import 'package:study_planner/widgets/sp_dialog.dart';
import 'package:study_planner/widgets/common/cw_app_state.dart';
import 'package:study_planner/widgets/common/cw_button.dart';
import 'package:study_planner/widgets/common/cw_card.dart';

class AnalysisOverviewPage extends StatefulWidget {
  const AnalysisOverviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _AnalysisOverviewPageState();
}

class _AnalysisOverviewPageState extends CWState<AnalysisOverviewPage> {
  late final StudyPlan studyPlan;
  int? creditsTotal;
  int? creditsNow;
  int? creditsOpen;
  double? meanCreditsSemster;
  double? semesterOpen;
  int? semesterCount;
  int? openSemester;
  int? creditsInMainPlan;

  int? plannedCreditsNow;
  int? plannedCreditsOpen;
  double? plannedMeanCreditsSemster;
  double? plannedSemesterOpen;
  int? plannedSemesterCount;
  int? plannedOpenSemester;
  double? plannedCreditsPerSemester;
  int? plannedCreditsInMainPlan;

  String? meanGrade;
  String? plannedMeanGrade;

  String? bestPossibleGrade;
  String? plannedBestPossibleGrade;

  @override
  void initState() {
    super.initState();
    GetIt.I<StudyPlanService>().loadStudyPlan().then((value) {
      setState(() {
        studyPlan = value!;
        if (studyPlan.creditsMain != null) {
          creditsTotal = studyPlan.creditsMain! + studyPlan.creditsOther!;
          creditsNow =
              StudyPlanUtils.sumOfCredits(studyPlan, onlyCompleted: false);
          creditsOpen = creditsTotal! - creditsNow!;
          semesterCount = studyPlan.semester.length;
          meanCreditsSemster = creditsNow! / semesterCount!;
          semesterOpen = max(creditsOpen! / meanCreditsSemster!, 0);
          openSemester = studyPlan.semesterCount! - semesterCount!;

          plannedCreditsNow =
              StudyPlanUtils.sumOfCredits(studyPlan, onlyCompleted: true);
          plannedSemesterCount =
              studyPlan.semester.where((element) => element.completed).length;
          plannedCreditsOpen = creditsTotal! - plannedCreditsNow!;
          plannedMeanCreditsSemster = plannedSemesterCount == 0
              ? 0
              : plannedCreditsNow! / plannedSemesterCount!;
          plannedSemesterOpen =
              max(plannedCreditsOpen! / plannedMeanCreditsSemster!, 0);
          if (plannedSemesterOpen == double.infinity) {}
          plannedOpenSemester =
              studyPlan.semesterCount! - plannedSemesterCount!;
          plannedCreditsPerSemester = plannedOpenSemester == 0
              ? 0
              : max(plannedCreditsOpen! / plannedOpenSemester!, 0);

          meanGrade = StudyPlanUtils.totalMeanGrade(
                studyPlan,
                onlyCompleted: true,
              )?.toStringAsFixed(2) ??
              '-';
          plannedMeanGrade = StudyPlanUtils.totalMeanGrade(
            studyPlan,
          )?.toStringAsFixed(2);

          creditsInMainPlan = StudyPlanUtils.sumOfCredits(studyPlan,
              onlyCompleted: true, fieldName: 'Hauptstudium');
          plannedCreditsInMainPlan =
              StudyPlanUtils.sumOfCredits(studyPlan, fieldName: 'Hauptstudium');

          bestPossibleGrade = StudyPlanUtils.bestPossibleMeanGrade(
            studyPlan,
            onlyCompleted: true,
          ).toStringAsFixed(2);
          plannedBestPossibleGrade =
              StudyPlanUtils.bestPossibleMeanGrade(studyPlan)
                  .toStringAsFixed(2);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      header: 'header.analysisOverview',
      content: () {
        if (studyPlan == null) {
          return <Widget>[];
        } else if (studyPlan.creditsMain == null) {
          return <Widget>[
            Text(
              'text.createStudyPlanFirst',
              style: Theme.of(context).textTheme.headline6,
            ),
            CWButton(
              label: 'button.label.goToStudyPlan',
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              onPressed: () => GetIt.I<NavigatorService>()
                  .navigateTo(const GeneralInformationPage()),
            ),
          ];
        }
        return [
          Wrap(
            children: [
              CWCard(
                title: 'label.credits',
                trailingTitle:
                    '${((plannedCreditsNow! / creditsTotal!) * 100).toStringAsFixed(2) ?? "-"}%',
                subTitle: 'text.totalCredits::$creditsTotal',
                info: [
                  'text.alreadyArchived::$plannedCreditsNow::$creditsNow',
                  'text.archivedInMainPlan::$creditsInMainPlan::$plannedCreditsInMainPlan',
                  'text.averageCreditsInSemester::$plannedMeanCreditsSemster',
                  'text.currentlyNeededCreditsInSemester::${plannedCreditsPerSemester!.toStringAsFixed(2)}',
                ],
                height: 310,
                color: Colors.blue,
              ),
              CWCard(
                title: 'label.grade',
                trailingTitle: meanGrade!,
                info: [
                  'text.bestPossibleGrade::$bestPossibleGrade',
                  'text.plannedBestPossibleGrade::$plannedBestPossibleGrade',
                ],
                height: 310,
                color: Colors.green,
              ),
              CWCard(
                title: 'label.semester',
                trailingTitle:
                    'text.currentSemester::${semesterCount! - plannedOpenSemester! + 1}',
                subTitle: 'text.goalSemester::$semesterCount',
                info: [
                  'text.openSemester::$plannedOpenSemester',
                  if (plannedSemesterOpen! < double.infinity)
                    'text.remainingSemester::${plannedSemesterOpen?.toStringAsFixed(1)}',
                  'text.plannedRemainingSemester::${semesterOpen?.toStringAsFixed(1)}',
                ],
                height: 310,
                color: Colors.red,
              ),
            ],
          ),
          Wrap(
            children: [
              SPBarChart<Semester>(
                id: 'credits',
                title: 'title.credits',
                data: studyPlan.semester,
                domainFn: (s, _) => s.name!,
                measureFn: (s, _) => StudyPlanUtils.creditsInSemester(s),
                average: meanCreditsSemster,
              ),
              SPBarChart<Semester>(
                id: 'courses',
                title: 'title.gpa',
                data: studyPlan.semester,
                domainFn: (s, _) => s.name!,
                labelFn: (s, _) =>
                    StudyPlanUtils.semesterMeanGrade(s)!.toStringAsFixed(2),
                measureFn: (s, _) => StudyPlanUtils.semesterMeanGrade(s),
                average: StudyPlanUtils.totalMeanGrade(studyPlan),
              ),
            ],
          ),
        ];
      },
    );
  }
}
