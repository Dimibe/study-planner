import 'package:flutter/material.dart';
import 'package:study_planner/models/Course.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyField.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/utils/StudyPlanUtils.dart';
import 'package:study_planner/widgets/SPModalDialog.dart';
import 'package:study_planner/widgets/common/CWBase.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWDropDown.dart';
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
    return SPModalDialog(
      content: [
        CWTextField(
          semanticLabel: 'semester',
          labelText: 'Semester',
          controller: myController0,
        ),
        CWDynamicContainer(
          showAddOption: true,
          showHideOption: true,
          padding: EdgeInsets.only(top: 8.0),
          contoller: dynamicControllers,
          initialData: () {
            return widget.semester?.courses
                ?.map((c) => {
                      'name': c.name,
                      'credits': c.credits,
                      'grade': c.grade,
                      'studyfield': c.studyField,
                    })
                ?.toList(growable: false);
          },
          children: <CWBase>[
            CWTextField(
              semanticLabel: 'name',
              labelText: 'Kurs Name',
              maxWidth: 200,
            ),
            CWTextField(
              semanticLabel: 'credits',
              labelText: 'Credits',
              maxWidth: 100,
            ),
            CWTextField(
              semanticLabel: 'grade',
              labelText: 'Note',
              maxWidth: 100,
            ),
            CWDropDown<String>(
              semanticLabel: 'studyfield',
              labelText: 'Kategorie',
              items: widget.plan.studyFields.map((e) => e.toString()).toList(),
              initValue: widget.plan.studyFields[0].toString(),
              maxWidth: 200,
            ),
          ],
        ),
      ],
      actions: (constraints) {
        var minWidth = 290.0;
        if (constraints.maxWidth < 450) {
          minWidth = 100.0;
        }
        return [
          FlatButton(
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
            minWidth: minWidth,
            onPressed: () {
              var courses = <Course>[];
              for (Map<String, dynamic> c in dynamicControllers.controllers) {
                var course = Course(
                  c['name'].text,
                  int.parse(c['credits'].text),
                );
                if (c['grade'].text != null && c['grade'].text.isNotEmpty) {
                  course.grade = double.parse(c['grade'].text);
                }
                if (c['studyfield'].value != null &&
                    c['studyfield'].value.isNotEmpty) {
                  course.studyField = StudyPlanUtils.getStudyFieldByName(
                      widget.plan, c['studyfield'].value);
                }
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
        ];
      },
    );
  }
}
