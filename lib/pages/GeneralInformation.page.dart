import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/pages/SemesterOverview.page.dart';
import 'package:study_planner/services/StudyPlanService.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/widgets/SPDialog.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

final GetIt getIt = GetIt.instance;

class GeneralInformationPage extends StatefulWidget {
  GeneralInformationPage({Key key}) : super(key: key);

  @override
  _GeneralInformationPageState createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage> {
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
    streamSubscription = getIt<UserService>().addAuthStateListener(
      (user) => getIt<StudyPlanService>().loadStudyPlan().then((plan) {
        this.studyPlan = plan;
        setState(() {
          _uniController.text = plan?.uni;
          _studiesController.text = plan?.studyName;
          _mainCreditsController.text = '${plan?.creditsMain ?? ""}';
          _otherCreditsController.text = '${plan?.creditsOther ?? ""}';
          _semeseterController.text = '${plan?.semesterCount ?? ""}';
        });
      }),
    );
  }

  @override
  void dispose() async {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      title: 'Study Planner!',
      content: <Widget>[
        Text(
          'Wikommen bei Study Planner!',
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 50.0)),
        Text(
          'Bitte gebe die folgenden Informationen ein:',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        CWTextField(
          labelText: 'Uni',
          controller: _uniController,
        ),
        CWTextField(
          labelText: 'Studiengang',
          controller: _studiesController,
        ),
        CWTextField(
          labelText: 'Credits Hauptstudium',
          hintText: 'Anzahl Credits',
          controller: _mainCreditsController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        CWTextField(
          labelText: 'Credits Auflagen etc.',
          hintText: 'Anzahl Credits',
          controller: _otherCreditsController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        CWTextField(
          labelText: 'Ziel Semesteranzahl',
          hintText: 'Anzahl Semester',
          controller: _semeseterController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        CWButton(
          label: 'Weiter',
          onPressed: () {
            saveStudyPlan();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SemesterOverviewPage()),
            );
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
    studyPlan.creditsOther = int.parse(_otherCreditsController.text);

    getIt<StudyPlanService>().saveStudyPlan(studyPlan);
  }
}
