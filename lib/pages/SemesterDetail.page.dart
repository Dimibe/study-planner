import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/Course.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/utils/StudyPlanUtils.dart';
import 'package:study_planner/widgets/SPModalDialog.dart';
import 'package:study_planner/widgets/common/CWAppState.dart';
import 'package:study_planner/widgets/common/CWBaseWidget.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWCheckBox.dart';
import 'package:study_planner/widgets/common/CWDropDown.dart';
import 'package:study_planner/widgets/common/CWDynamicContainer.dart';
import 'package:study_planner/widgets/common/CWText.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

class SemesterDetailPage extends StatefulWidget {
  final Semester semester;
  final StudyPlan plan;

  SemesterDetailPage({Key key, this.plan, this.semester}) : super(key: key);

  @override
  _SemesterDetailPageState createState() => _SemesterDetailPageState();
}

class _SemesterDetailPageState extends CWState<SemesterDetailPage> {
  var semesterController;
  var dynamicControllers = CWDynamicController();
  var checkBoxController = CheckBoxController();

  @override
  void initState() {
    super.initState();
    semesterController = TextEditingController(text: widget?.semester?.name);
    checkBoxController.value = widget?.semester?.completed;
  }

  @override
  Widget build(BuildContext context) {
    return SPModalDialog(
      padding: 15.0,
      content: [
        Row(
          children: [
            Row(
              children: [
                CWTextField(
                  id: 'semester',
                  labelText: 'label.semester',
                  mandatory: true,
                  controller: semesterController,
                ),
                CWCheckBox(
                  id: 'semesterdone',
                  label: 'label.semesterDone',
                  controller: checkBoxController,
                  tooltip: 'tooltip.semesterDone',
                ),
              ],
            ),
          ],
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
          children: <CWBaseWidget>[
            CWTextField(
              id: 'name',
              labelText: 'label.courseName',
              mandatory: true,
              maxWidth: 200,
            ),
            CWTextField(
              id: 'credits',
              labelText: 'label.credits',
              inputType: CWInputType.Decimal,
              mandatory: true,
              maxWidth: 100,
            ),
            CWTextField(
              id: 'grade',
              labelText: 'label.grade',
              inputType: CWInputType.Decimal,
              maxWidth: 100,
            ),
            CWDropDown<String>(
              id: 'studyfield',
              labelText: 'label.studyField',
              items: widget.plan.studyFields.map((e) => e.toString()).toList(),
              initValue: widget.plan.studyFields[0].toString(),
              maxWidth: 184,
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
                    GetIt.I<StudyPlanService>().saveStudyPlan(widget.plan);
                    Navigator.pop(context, true);
                  },
            child: CWText(
              'button.label.delete',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          ),
          CWButton(
            label: 'button.label.save',
            minWidth: minWidth,
            validateOnClick: true,
            onPressed: () {
              var courses = <Course>[];
              for (Map<String, dynamic> c in dynamicControllers.controllers) {
                if (c['name'].text.isNotEmpty && c['credits'].text.isNotEmpty) {
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
              }
              var s = widget.semester ?? Semester();
              s.name = semesterController.text;
              s.completed = checkBoxController.value;
              s.courses = courses;
              if (widget.semester == null) {
                widget.plan.semester.add(s);
              }
              GetIt.I<StudyPlanService>().saveStudyPlan(widget.plan);
              Navigator.pop(context, true);
            },
          ),
        ];
      },
    );
  }
}
