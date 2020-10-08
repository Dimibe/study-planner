import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/pages/SemesterOverview.page.dart';
import 'package:study_planner/services/StorageService.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

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

  @override
  void initState() {
    super.initState();
    StorageService.loadStudyPlan().then((plan) {
      this.studyPlan = plan;
      setState(() {
        _uniController.text = plan?.uni;
        _studiesController.text = plan?.studyName;
        _mainCreditsController.text = plan?.creditsMain;
        _otherCreditsController.text = plan?.creditsOther;
        _semeseterController.text = plan?.semesterCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Planner!'),
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: SPDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to study planner!',
                style: Theme.of(context).textTheme.headline2,
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              Text(
                'Please type in the following information:',
                style: Theme.of(context).textTheme.headline6,
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
                    MaterialPageRoute(
                        builder: (context) => SemesterOverviewPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveStudyPlan() {
    studyPlan ??= StudyPlan();

    studyPlan.uni = _uniController.text;
    studyPlan.studyName = _studiesController.text;
    studyPlan.semesterCount = _semeseterController.text;
    studyPlan.creditsMain = _mainCreditsController.text;
    studyPlan.creditsOther = _otherCreditsController.text;

    StorageService.saveStudyPlan(studyPlan);
  }
}
