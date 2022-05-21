import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/course.dart';
import 'package:study_planner/models/semester.dart';
import 'package:study_planner/models/study_plan.dart';
import 'package:study_planner/services/study_plan.service.dart';
import 'package:study_planner/utils/study_plan_utils.dart';
import 'package:study_planner/widgets/sp_modal_dialog.dart';
import 'package:study_planner/widgets/common/cw_app_state.dart';
import 'package:study_planner/widgets/common/cw_base_widget.dart';
import 'package:study_planner/widgets/common/cw_button.dart';
import 'package:study_planner/widgets/common/cw_checkbox.dart';
import 'package:study_planner/widgets/common/cw_dropdown.dart';
import 'package:study_planner/widgets/common/cw_dynamic_container.dart';
import 'package:study_planner/widgets/common/cw_text.dart';
import 'package:study_planner/widgets/common/cw_textfield.dart';

class SemesterDetailPage extends StatefulWidget {
  final StudyPlan plan;
  final Semester? semester;

  const SemesterDetailPage({super.key, required this.plan, this.semester});

  @override
  CWState<SemesterDetailPage> createState() => _SemesterDetailPageState();
}

class _SemesterDetailPageState extends CWState<SemesterDetailPage> {
  late final TextEditingController semesterController;
  var dynamicControllers = CWDynamicController();
  var checkBoxController = CheckBoxController();

  @override
  void initState() {
    super.initState();
    semesterController = TextEditingController(text: widget.semester?.name);
    checkBoxController.value = widget.semester?.completed;
  }

  @override
  Widget build(BuildContext context) {
    return SPModalDialog(
      padding: 15.0,
      content: [
        Wrap(
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
        CWDynamicContainer(
          showAddOption: true,
          showHideOption: true,
          padding: const EdgeInsets.only(top: 8.0),
          contoller: dynamicControllers,
          initialData: () {
            return widget.semester?.courses
                .map((c) => {
                      'name': c.name,
                      'credits': c.credits,
                      'grade': c.grade,
                      'studyfield': c.studyField,
                    })
                .toList(growable: false);
          },
          children: <CWBaseWidget>[
            const CWTextField(
              id: 'name',
              labelText: 'label.courseName',
              mandatory: true,
              maxWidth: 200,
            ),
            const CWTextField(
              id: 'credits',
              labelText: 'label.credits',
              inputType: CWInputType.decimal,
              mandatory: true,
              maxWidth: 100,
            ),
            const CWTextField(
              id: 'grade',
              labelText: 'label.grade',
              inputType: CWInputType.decimal,
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
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
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
              s.completed = checkBoxController.value!;
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
