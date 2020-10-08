import 'package:flutter/material.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:charts_flutter/flutter.dart';

class AnalysisOverviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnalysisOverviewPageState();
}

class _AnalysisOverviewPageState extends State<AnalysisOverviewPage> {
  StudyPlan _studyPlan;
  List<Series<dynamic, String>> data = [];

  @override
  void initState() {
    super.initState();
    StorageService.loadStudyPlan().then(
      (p) => setState(() {
        _studyPlan = p;
        data = getData();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      content: [
        Container(
          width: 400,
          height: 400,
          child: BarChart(
            data,
            animate: true,
            // barGroupingType: BarGroupingType.stacked,
          ),
        ),
      ],
    );
  }

  List<Series<Semester, String>> getData() {
    return [
      Series(
        id: 'courses',
        data: _studyPlan.semester,
        domainFn: (semester, _) => semester.name,
        measureFn: (semester, _) =>
            semester.courses.map((c) => c.credits).reduce((c1, c2) => c1 + c2),
        colorFn: (semester, _) {
          var theme = Theme.of(context).accentColor;
          return Color(r: theme.red, g: theme.green, b: theme.blue);
        },
      ),
    ];
  }
}
