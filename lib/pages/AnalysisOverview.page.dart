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
          Text(
            'Analyse',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            constraints: BoxConstraints(maxWidth: 700),
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                showBottomBorder: true,
                columns: [
                  DataColumn(label: Text('Titel')),
                  DataColumn(label: Text('Wert')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Gesamt Credits')),
                      DataCell(Text('$creditsTotal')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Bereits erworbene Credits')),
                      DataCell(Text(
                          '$creditsNow (${((creditsNow / creditsTotal) * 100)?.toStringAsFixed(2) ?? "-"}%)')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Wunsch Semesteranzahl')),
                      DataCell(Text(
                          '${studyPlan.semesterCount} ($openSemester offene)')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Credits pro Semester für Wunschziel')),
                      DataCell(Text(
                          '${creditsPerSemester.toStringAsFixed(1)} in $openSemester Semester')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(
                          'Verbleibende Semester mit Credits Drchschnitt')),
                      DataCell(Text(semesterOpen?.toStringAsFixed(1) ?? '-')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Durchschnitt Note')),
                      DataCell(Text(StudyPlanUtils.totalMeanGrade(studyPlan)
                              ?.toStringAsFixed(2) ??
                          '-')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Durchschnitt Credits pro Semester')),
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
                title: 'Credits',
                data: studyPlan.semester,
                domainFn: (s, _) => s.name,
                measureFn: (s, _) => StudyPlanUtils.creditsInSemester(s),
                average: meanCreditsSemster,
              ),
              SPBarChart(
                id: 'courses',
                title: 'Notendurchschnitt',
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
