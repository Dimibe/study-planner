import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import './semester_detail.page.dart';
import '../models/semester.dart';
import '../models/study_plan.dart';
import '../services/study_plan.service.dart';
import '../widgets/sp_data_table.dart';
import '../widgets/sp_dialog.dart';
import '../widgets/common/cw_app_state.dart';
import '../widgets/common/cw_button.dart';
import '../widgets/common/cw_text.dart';

class SemesterOverviewPage extends StatefulWidget {
  const SemesterOverviewPage({super.key});

  @override
  CWState<SemesterOverviewPage> createState() => _SemesterOverviewPageState();
}

class _SemesterOverviewPageState extends CWState<SemesterOverviewPage> {
  StudyPlan? studyPlan;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    GetIt.I<StudyPlanService>().loadStudyPlan().then((plan) {
      setState(() {
        studyPlan = plan;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      header: 'header.semesterOverview',
      content: () {
        var content = <Widget>[];
        if (studyPlan == null) return content;
        if (studyPlan!.semester.isEmpty) {
          content.add(
            CWText(
              'text.noSemesterPlaceholder',
              style: Theme.of(context).textTheme.headline6,
            ),
          );
        } else {
          content.add(Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Wrap(children: _getSemesterData()),
          ));
        }
        content.add(
          CWButton(
            label: 'button.label.addSemester',
            padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
            onPressed: getClickFunction(null),
          ),
        );
        return content;
      },
    );
  }

  List<Widget> _getSemesterData() {
    var content = <Widget>[];
    content.addAll(studyPlan!.semester.map((s) {
      return SPDataTable(semester: s, onEdit: getClickFunction(s));
    }));
    return content;
  }

  Function() getClickFunction(Semester? s) {
    return () async {
      var res = await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return SemesterDetailPage(plan: studyPlan!, semester: s);
          });
      if (res) {
        _initData();
      }
    };
  }
}
