import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';
import 'package:study_planner/services/NavigatorService.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/utils/StudyPlanUtils.dart';
import 'package:study_planner/widgets/SPBarChart.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWAppState.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWText.dart';

class AnalysisOverviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnalysisOverviewPageState();
}

class _AnalysisOverviewPageState extends CWState<AnalysisOverviewPage> {
  StudyPlan studyPlan;
  int creditsTotal;
  int creditsNow;
  int creditsOpen;
  double meanCreditsSemster;
  double semesterOpen;
  int semesterCount;
  int openSemester;
  double creditsPerSemester;

  @override
  void initState() {
    super.initState();
    GetIt.I<StudyPlanService>().loadStudyPlan().then((value) {
      setState(() {
        studyPlan = value;
        if (studyPlan.creditsMain != null) {
          creditsTotal = studyPlan.creditsMain + studyPlan.creditsOther;
          creditsNow = StudyPlanUtils.sumOfCredits(studyPlan);
          creditsOpen = creditsTotal - creditsNow;
          meanCreditsSemster = creditsNow / studyPlan.semester.length;
          semesterOpen = max(creditsOpen / meanCreditsSemster, 0);
          semesterCount = studyPlan.semester.length;
          openSemester = studyPlan.semesterCount - semesterCount;
          creditsPerSemester =
              openSemester == 0 ? 0 : max(creditsOpen / openSemester, 0);
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
              'Erstelle zuerst dein Studienplan..',
              style: Theme.of(context).textTheme.headline6,
            ),
            CWButton(
              label: 'Zum Studienplan',
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              onPressed: () => GetIt.I<NavigatorService>()
                  .navigateTo(GeneralInformationPage()),
            ),
          ];
        }
        return [
          Container(
            padding: EdgeInsets.all(16.0),
            constraints: BoxConstraints(maxWidth: 700),
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                showBottomBorder: true,
                columns: [
                  DataColumn(label: Text('Wert')),
                  DataColumn(label: CWText('label.title')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(CWText('label.totalCredits')),
                      DataCell(Text('$creditsTotal')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(CWText('label.aquiredCredits')),
                      DataCell(Text(
                          '$creditsNow (${((creditsNow / creditsTotal) * 100)?.toStringAsFixed(2) ?? "-"}%)')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(CWText('label.semesterGoal')),
                      DataCell(Text(
                          '${studyPlan.semesterCount} ($openSemester offene)')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(CWText('label.creditsForGoal')),
                      DataCell(Text(
                          '${creditsPerSemester.toStringAsFixed(1)} in $openSemester Semester')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(CWText('label.remainingSemester')),
                      DataCell(Text(semesterOpen?.toStringAsFixed(1) ?? '-')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(StudyPlanUtils.totalMeanGrade(studyPlan)
                              ?.toStringAsFixed(2) ??
                          '-')),
                      DataCell(CWText('label.averageGrade')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(CWText('text.meanCreditsSemester')),
                      DataCell(Text(meanCreditsSemster?.toStringAsFixed(2))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            children: [
              SPBarChart<Semester>(
                id: 'credits',
                title: 'title.credits',
                data: studyPlan.semester,
                domainFn: (s, _) => s.name,
                measureFn: (s, _) => StudyPlanUtils.creditsInSemester(s),
                average: meanCreditsSemster,
              ),
              SPBarChart(
                id: 'courses',
                title: 'title.gpa',
                data: studyPlan.semester,
                domainFn: (s, _) => s.name,
                labelFn: (s, _) =>
                    StudyPlanUtils.semesterMeanGrade(s).toStringAsFixed(2),
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
