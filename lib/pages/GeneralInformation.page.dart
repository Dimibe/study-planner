import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWAppState.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
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
      header: 'Studienplan',
      content: <Widget>[
        Text(
          'Bitte gebe die folgenden Informationen ein:',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        CWTextField(
          labelText: 'Uni',
          controller: _uniController,
          mandatory: true,
        ),
        CWTextField(
          labelText: 'Studiengang',
          controller: _studiesController,
        ),
        CWTextField(
          labelText: 'Credits Hauptstudium',
          hintText: 'Anzahl Credits',
          controller: _mainCreditsController,
          inputType: CWInputType.Integer,
          mandatory: true,
        ),
        CWTextField(
          labelText: 'Credits Auflagen etc.',
          hintText: 'Anzahl Credits',
          controller: _otherCreditsController,
          inputType: CWInputType.Integer,
        ),
        CWTextField(
          labelText: 'Ziel Semesteranzahl',
          hintText: 'Anzahl Semester',
          controller: _semeseterController,
          inputType: CWInputType.Integer,
          mandatory: true,
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        CWButton(
          label: 'Speichern',
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
