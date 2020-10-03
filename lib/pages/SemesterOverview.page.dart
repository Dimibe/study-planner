import 'package:flutter/material.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/pages/SemesterDetail.page.dart';
import 'package:study_planner/services/StorageService.dart';
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
    return [
      DataTable(
        columns: [
          DataColumn(label: Text('Kurs')),
          DataColumn(label: Text('Credits')),
        ],
        rows: List<DataRow>.generate(
          studyPlan.semester[0].courses.length,
          (index) {
            var course = studyPlan.semester[0].courses[index];
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected))
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.08);
                if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
                return null; // Use the default value.
              }),
              cells: [
                DataCell(Text(course.name)),
                DataCell(Text('${course.credits}')),
              ],
            );
          },
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[
      Padding(padding: EdgeInsets.only(top: 50.0)),
    ];

    content.addAll(getContent());

    content.addAll(
      [
        Padding(padding: EdgeInsets.only(top: 16.0)),
        ButtonTheme(
          minWidth: 290,
          height: 60,
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return SemesterDetailPage();
                  });
            },
            child: Text(
              'Semester hinzufügen',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );

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
