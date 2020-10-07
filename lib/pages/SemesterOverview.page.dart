import 'package:flutter/material.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/pages/SemesterDetail.page.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/widgets/SPDataTable.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

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
    initData();
  }

  void initData() {
    StorageService.loadStudyPlan().then((plan) {
      setState(() {
        this.studyPlan = plan;
      });
    });
  }

  List<Widget> getContent() {
    if (studyPlan == null ||
        studyPlan.semester == null ||
        studyPlan.semester.isEmpty) {
      return [
        Text(
          'Noch keine Semester vorhanden..',
          style: Theme.of(context).textTheme.headline6,
        ),
      ];
    }
    var content = <Widget>[];
    content.addAll(studyPlan.semester.map((s) => SPDataTable(semester: s)));
    return content;
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[
      Padding(padding: EdgeInsets.only(top: 50.0)),
    ];

    content.addAll(getContent());

    content.add(Padding(padding: EdgeInsets.only(top: 16.0)));
    content.add(
      ButtonTheme(
        minWidth: 290,
        height: 60,
        child: RaisedButton(
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: () async {
            var res = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return SemesterDetailPage();
                });
            if (res) {
              initData();
            }
          },
          child: Text(
            'Semester hinzufügen',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
    content.add(Padding(padding: EdgeInsets.only(top: 16.0)));

    return Scaffold(
      appBar: AppBar(
        title: Text('Study Planner!'),
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: SPDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: content,
          ),
        ),
      ),
    );
  }
}
