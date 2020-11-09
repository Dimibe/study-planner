import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWAppState.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWText.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

final GetIt getIt = GetIt.instance;

class GeneralInformationPage extends StatefulWidget {
  GeneralInformationPage({Key key}) : super(key: key);

  @override
  _GeneralInformationPageState createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends CWState<GeneralInformationPage> {
  final _uniController = TextEditingController();
  final _studiesController = TextEditingController();
  final _mainCreditsController = TextEditingController();
  final _otherCreditsController = TextEditingController();
  final _semeseterController = TextEditingController();
  StudyPlan studyPlan;
  var streamSubscription;

  @override
  void initState() {
    super.initState();
    getIt<StudyPlanService>().loadStudyPlan().then(
      (plan) {
        this.studyPlan = plan;
        setState(() {
          _uniController.text = plan?.uni;
          _studiesController.text = plan?.studyName;
          _mainCreditsController.text = '${plan?.creditsMain ?? ""}';
          _otherCreditsController.text = '${plan?.creditsOther ?? ""}';
          _semeseterController.text = '${plan?.semesterCount ?? ""}';
        });
      },
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
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
        Padding(padding: EdgeInsets.only(top: 16.0)),
        CWTextField(
          labelText: 'label.university',
          controller: _uniController,
          mandatory: true,
        ),
        CWTextField(
          labelText: 'label.courseOfStudies',
          controller: _studiesController,
        ),
        CWTextField(
          labelText: 'label.creditsCount',
          hintText: 'hint.creditsCount',
          controller: _mainCreditsController,
          inputType: CWInputType.Integer,
          mandatory: true,
        ),
        CWTextField(
          labelText: 'label.creditsOther',
          hintText: 'hint.creditsCount',
          controller: _otherCreditsController,
          inputType: CWInputType.Integer,
        ),
        CWTextField(
          labelText: 'label.semesterGoal',
          hintText: 'hint.semesterCount',
          controller: _semeseterController,
          inputType: CWInputType.Integer,
          mandatory: true,
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        CWButton(
          label: 'button.label.save',
          validateOnClick: true,
          onPressed: () {
            saveStudyPlan();
          },
        ),
      ],
    );
  }

  void saveStudyPlan() {
    studyPlan ??= StudyPlan();
    studyPlan.uni = _uniController.text;
    studyPlan.studyName = _studiesController.text;
    studyPlan.semesterCount = int.parse(_semeseterController.text);
    studyPlan.creditsMain = int.parse(_mainCreditsController.text);
    studyPlan.creditsOther = _otherCreditsController.text.isNotEmpty
        ? int.parse(_otherCreditsController.text)
        : null;

    getIt<StudyPlanService>().saveStudyPlan(studyPlan);
  }
}
