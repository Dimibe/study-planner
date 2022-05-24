import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/course.dart';
import '../models/semester.dart';
import '../models/study_plan.dart';
import '../services/study_plan.service.dart';
import '../utils/study_plan_utils.dart';
import '../widgets/sp_modal_dialog.dart';
import '../widgets/common/cw_app_state.dart';
import '../widgets/common/cw_base_widget.dart';
import '../widgets/common/cw_button.dart';
import '../widgets/common/cw_checkbox.dart';
import '../widgets/common/cw_dropdown.dart';
import '../widgets/common/cw_dynamic_container.dart';
import '../widgets/common/cw_text.dart';
import '../widgets/common/cw_textfield.dart';

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
                    name: c['name'].text,
                    credits: int.parse(c['credits'].text),
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
              if (widget.semester != null) {
                widget.semester!.name = semesterController.text;
                widget.semester!.completed = checkBoxController.value!;
                widget.semester!.courses = courses;
              } else {
                var semester = Semester(
                  name: semesterController.text,
                  completed: checkBoxController.value!,
                  courses: courses,
                );
                widget.plan.semester.add(semester);
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
