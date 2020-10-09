import 'package:flutter/material.dart';
import 'package:study_planner/models/Course.dart';
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
  List<Series<dynamic, String>> _creditsData = [];
  List<Series<dynamic, String>> _gradesData = [];

  @override
  void initState() {
    super.initState();
    StorageService.loadStudyPlan().then(
      (p) => setState(() {
        _studyPlan = p;
        _creditsData = _getCreditsData();
        _gradesData = _getGradesData();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      content: [
        Container(
          padding: EdgeInsets.all(8.0),
          width: 300,
          height: 300,
          child: BarChart(
            _creditsData,
            animate: true,
            defaultInteractions: false,
            behaviors: [ChartTitle('Credits')],
            barRendererDecorator: BarLabelDecorator<String>(),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          width: 300,
          height: 300,
          child: BarChart(
            _gradesData,
            animate: true,
            defaultInteractions: false,
            behaviors: [ChartTitle('Notendurchschnitt')],
            barRendererDecorator: BarLabelDecorator<String>(),
          ),
        ),
      ],
    );
  }

  List<Series<Semester, String>> _getGradesData() {
    num _measure(semester, _) {
      var courses = semester.courses.where((c) => c.grade != null);
      var sum =
          courses.map((c) => c.grade * c.credits).reduce((c1, c2) => c1 + c2);

      var mean =
          (sum / courses.map((c) => c.credits).reduce((c1, c2) => c1 + c2));
      return num.parse(mean.toStringAsFixed(2));
    }

    return [
      Series(
        id: 'courses',
        data: _studyPlan.semester,
        domainFn: (semester, _) => semester.name,
        measureFn: _measure,
        labelAccessorFn: (semester, _) => '${_measure(semester, _)}',
        colorFn: (semester, _) {
          var theme = Theme.of(context).accentColor;
          return Color(r: theme.red, g: theme.green, b: theme.blue);
        },
      ),
    ];
  }

  List<Series<Semester, String>> _getCreditsData() {
    num _measure(semester, _) {
      return semester.courses.map((c) => c.credits).reduce((c1, c2) => c1 + c2);
    }

    return [
      Series(
        id: 'courses',
        data: _studyPlan.semester,
        domainFn: (semester, _) => semester.name,
        measureFn: _measure,
        labelAccessorFn: (semester, _) => '${_measure(semester, _)}',
        colorFn: (semester, _) {
          var theme = Theme.of(context).accentColor;
          return Color(r: theme.red, g: theme.green, b: theme.blue);
        },
      ),
    ];
  }
}
