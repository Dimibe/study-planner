import 'package:flutter/material.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/utils/StudyPlanUtils.dart';
import 'package:study_planner/widgets/SPBarChart.dart';
import 'package:study_planner/widgets/SPDialog.dart';

class AnalysisOverviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnalysisOverviewPageState();
}

class _AnalysisOverviewPageState extends State<AnalysisOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return SPDialog(
      dependsOn: StorageService.loadStudyPlan(),
      content: (StudyPlan studyPlan) {
        var creditsTotal = int.parse(studyPlan.creditsMain) +
            int.parse(studyPlan.creditsOther);
        var creditsNow = StudyPlanUtils.sumOfCredits(studyPlan);
        var creditsOpen = creditsTotal - creditsNow;
        var meanCreditsSemster = creditsNow / studyPlan.semester.length;
        var semesterOpen = creditsOpen / meanCreditsSemster;
        var semesterCount = studyPlan.semester.length;
        var openSemester = int.parse(studyPlan.semesterCount) - semesterCount;
        var creditsPerSemester = creditsOpen / openSemester;

        return <Widget>[
          SizedBox(
            width: double.infinity,
            child: DataTable(
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
                    DataCell(Text('$creditsNow')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Wunsch Semesteranzahl')),
                    DataCell(Text('${studyPlan.semesterCount}')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Credits pro Semester für Wunschziel')),
                    DataCell(
                        Text('$creditsPerSemester in $openSemester Semester')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                        Text('Verbleibende Semester mit Credits Drchschnitt')),
                    DataCell(Text('$semesterOpen')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Durchschnitt Note')),
                    DataCell(Text(StudyPlanUtils.totalMeanGrade(studyPlan)
                        .toStringAsFixed(2))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Durchschnitt Credits pro Semester')),
                    DataCell(Text('$meanCreditsSemster')),
                  ],
                ),
              ],
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
              ),
              SPBarChart(
                id: 'courses',
                title: 'Notendurchschnitt',
                data: studyPlan.semester,
                domainFn: (s, _) => s.name,
                labelFn: (s, _) =>
                    StudyPlanUtils.meanGrade(s).toStringAsFixed(2),
                measureFn: (s, _) => StudyPlanUtils.meanGrade(s),
              ),
            ],
          ),
        ];
      },
    );
  }
}
