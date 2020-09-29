import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

class GeneralInformationPage extends StatefulWidget {
  GeneralInformationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GeneralInformationPageState createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage> {
  final myController0 = TextEditingController();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: SPDrawer(),
      body: Center(
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
              controller: myController0,
            ),
            CWTextField(
              labelText: 'Studiengang',
              controller: myController1,
            ),
            CWTextField(
              labelText: 'Credits Hauptstudium',
              hintText: 'Anzahl Credits',
              controller: myController2,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            CWTextField(
              labelText: 'Credits Auflagen etc.',
              hintText: 'Anzahl Credits',
              controller: myController3,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            CWTextField(
              labelText: 'Ziel Semesteranzahl',
              hintText: 'Anzahl Semester',
              controller: myController4,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 16.0)),
            ButtonTheme(
              minWidth: 290,
              height: 60,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () {},
                child: Text(
                  'Weiter',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
