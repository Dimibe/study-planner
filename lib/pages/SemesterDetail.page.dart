import 'package:flutter/material.dart';
import 'package:study_planner/models/Course.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWDynamicContainer.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

class SemesterDetailPage extends StatefulWidget {
  final Semester semester;
  final StudyPlan plan;

  SemesterDetailPage({Key key, this.plan, this.semester}) : super(key: key);

  @override
  _SemesterDetailPageState createState() => _SemesterDetailPageState();
}

class _SemesterDetailPageState extends State<SemesterDetailPage> {
  var myController0;
  var dynamicControllers = CWDynamicController();

  @override
  void initState() {
    super.initState();
    myController0 = TextEditingController(text: widget?.semester?.name);
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
                initialData: () {
                  return widget.semester?.courses
                      ?.map((c) => {'Kurs': c.name, 'Credits': c.credits})
                      ?.toList(growable: false);
                },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    padding: EdgeInsets.only(right: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    onPressed: widget.semester == null
                        ? null
                        : () {
                            widget.plan.semester.remove(widget.semester);
                            StorageService.saveStudyPlan(widget.plan);
                            Navigator.pop(context, true);
                          },
                    child: Text(
                      'Löschen',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  ),
                  CWButton(
                    label: 'Speichern',
                    onPressed: () {
                      var courses = <Course>[];
                      for (Map<String, TextEditingController> c
                          in dynamicControllers.controllers) {
                        var course = Course(
                            c['Kurs'].text, int.parse(c['Credits'].text));
                        courses.add(course);
                      }
                      var s = widget.semester ?? Semester();
                      s.name = myController0.text;
                      s.courses = courses;
                      if (widget.semester == null) {
                        widget.plan.semester.add(s);
                      }
                      StorageService.saveStudyPlan(widget.plan);
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
