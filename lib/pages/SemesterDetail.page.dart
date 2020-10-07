import 'package:flutter/material.dart';
import 'package:study_planner/models/Course.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWDynamicContainer.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

class SemesterDetailPage extends StatefulWidget {
  SemesterDetailPage({Key key}) : super(key: key);

  @override
  _SemesterDetailPageState createState() => _SemesterDetailPageState();
}

class _SemesterDetailPageState extends State<SemesterDetailPage> {
  final myController0 = TextEditingController();
  final dynamicControllers = CWDynamicController();
  StudyPlan plan;

  @override
  void initState() {
    super.initState();
    StorageService.loadStudyPlan().then((value) => plan = value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Container(
        padding: EdgeInsets.all(30.0),
        constraints: BoxConstraints(maxWidth: 700),
        //  padding: EdgeInsets.all(150.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CWTextField(
                labelText: 'Semester',
                controller: myController0,
              ),
              CWDynamicContainer(
                showAddOption: true,
                showHideOption: true,
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                contoller: dynamicControllers,
                children: [
                  CWTextField(
                    labelText: 'Kurs',
                    helperText: 'Name',
                    maxWidth: 200,
                  ),
                  CWTextField(
                    labelText: 'Credits',
                    helperText: 'Anzahl',
                    maxWidth: 200,
                  ),
                  CWTextField(
                    labelText: 'Kategorie',
                    helperText: 'Comming soon..',
                    maxWidth: 200,
                  ),
                ],
              ),
              CWButton(
                label: 'Speichern',
                onPressed: () {
                  var courses = <Course>[];
                  for (Map<String, TextEditingController> c
                      in dynamicControllers.controllers) {
                    var course =
                        Course(c['Kurs'].text, int.parse(c['Credits'].text));
                    courses.add(course);
                  }
                  var s = Semester(myController0.text, courses);
                  plan.semester ??= [];
                  plan.semester.add(s);
                  StorageService.saveStudyPlan(plan);
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
