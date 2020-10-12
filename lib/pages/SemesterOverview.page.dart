import 'package:flutter/material.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/pages/SemesterDetail.page.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/widgets/SPDataTable.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';

class SemesterOverviewPage extends StatefulWidget {
  SemesterOverviewPage({Key key}) : super(key: key);

  @override
  _SemesterOverviewPageState createState() => _SemesterOverviewPageState();
}

class _SemesterOverviewPageState extends State<SemesterOverviewPage> {
  StudyPlan studyPlan;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    StorageService.loadStudyPlan().then((plan) {
      setState(() {
        this.studyPlan = plan;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      title: 'Study Planner!',
      content: () {
        var content = <Widget>[];
        if (studyPlan == null ||
            studyPlan.semester == null ||
            studyPlan.semester.isEmpty) {
          content.add(
            Text(
              'Noch keine Semester vorhanden..',
              style: Theme.of(context).textTheme.headline6,
            ),
          );
        } else {
          content.addAll(_getSemesterData());
        }
        content.add(
          CWButton(
            label: 'Semester Hinzufügen',
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            onPressed: () async {
              var res = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return SemesterDetailPage(plan: studyPlan);
                  });
              if (res) {
                _initData();
              }
            },
          ),
        );
        return content;
      },
    );
  }

  List<Widget> _getSemesterData() {
    var content = <Widget>[];
    content.addAll(studyPlan.semester.map((s) {
      var onEdit = () async {
        var res = await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return SemesterDetailPage(plan: studyPlan, semester: s);
            });
        if (res) {
          _initData();
        }
      };
      return SPDataTable(semester: s, onEdit: onEdit);
    }));
    return content;
  }
}
