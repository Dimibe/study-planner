import 'package:flutter/material.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/services/StorageService.dart';
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
      content: (studyPlan) {
        return <Widget>[
          SPBarChart<Semester>(
            id: 'credits',
            title: 'Credits',
            data: studyPlan.semester,
            domainFn: (s, _) => s.name,
            measureFn: (s, _) =>
                s.courses.map((c) => c.credits).reduce((c1, c2) => c1 + c2),
          ),
          SPBarChart(
            id: 'courses',
            title: 'Notendurchschnitt',
            data: studyPlan.semester,
            domainFn: (s, _) => s.name,
            measureFn: (s, _) {
              var courses = s.courses.where((c) => c.grade != null);
              var sum = courses
                  .map((c) => c.grade * c.credits)
                  .reduce((v1, v2) => v1 + v2);

              var mean = (sum /
                  courses.map((c) => c.credits).reduce((c1, c2) => c1 + c2));
              return num.parse(mean.toStringAsFixed(2));
            },
          ),
        ];
      },
    );
  }
}
