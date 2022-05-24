import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/study_plan.dart';
import '../services/study_plan.service.dart';
import '../widgets/sp_dialog.dart';
import '../widgets/common/cw_app_state.dart';
import '../widgets/common/cw_button.dart';
import '../widgets/common/cw_text.dart';
import '../widgets/common/cw_textfield.dart';

final GetIt getIt = GetIt.instance;

class GeneralInformationPage extends StatefulWidget {
  const GeneralInformationPage({super.key});

  @override
  CWState<GeneralInformationPage> createState() =>
      _GeneralInformationPageState();
}

class _GeneralInformationPageState extends CWState<GeneralInformationPage> {
  final _uniController = TextEditingController();
  final _studiesController = TextEditingController();
  final _mainCreditsController = TextEditingController();
  final _otherCreditsController = TextEditingController();
  final _semeseterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIt<StudyPlanService>().loadStudyPlan().then(
      (plan) {
        setState(() {
          _uniController.text = '${plan?.uni}';
          _studiesController.text = '${plan?.studyName}';
          _mainCreditsController.text = '${plan?.creditsMain}';
          _otherCreditsController.text = '${plan?.creditsOther}';
          _semeseterController.text = '${plan?.semesterCount}';
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      header: 'header.generalInformation',
      content: <Widget>[
        CWText(
          'text.generalInformationInstruction',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(top: 16.0)),
        CWTextField(
          id: 'uni',
          labelText: 'label.university',
          controller: _uniController,
          mandatory: true,
        ),
        CWTextField(
          id: 'uni',
          labelText: 'label.courseOfStudies',
          controller: _studiesController,
        ),
        CWTextField(
          id: 'uni',
          labelText: 'label.creditsCount',
          hintText: 'hint.creditsCount',
          controller: _mainCreditsController,
          inputType: CWInputType.integer,
          mandatory: true,
        ),
        CWTextField(
          id: 'uni',
          labelText: 'label.creditsOther',
          hintText: 'hint.creditsCount',
          controller: _otherCreditsController,
          inputType: CWInputType.integer,
        ),
        CWTextField(
          id: 'uni',
          labelText: 'label.semesterGoal',
          hintText: 'hint.semesterCount',
          controller: _semeseterController,
          inputType: CWInputType.integer,
          mandatory: true,
        ),
        const Padding(padding: EdgeInsets.only(top: 16.0)),
        CWButton(
          label: 'button.label.save',
          validateOnClick: true,
          onPressed: saveStudyPlan,
        ),
      ],
    );
  }

  void saveStudyPlan() {
    var studyPlan = StudyPlan(
      uni: _uniController.text,
      studyName: _studiesController.text,
      semesterCount: int.parse(_semeseterController.text),
      creditsMain: int.parse(_mainCreditsController.text),
      creditsOther: _otherCreditsController.text.isNotEmpty
          ? int.parse(_otherCreditsController.text)
          : null,
    );

    getIt<StudyPlanService>().loadStudyPlan().then((value) {
      if (value != null) {
        studyPlan.semester = value.semester;
        studyPlan.studyFields = value.studyFields;
      }
      getIt<StudyPlanService>().saveStudyPlan(studyPlan);
    });
  }
}
