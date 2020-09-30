import 'package:flutter/material.dart';
import 'package:study_planner/pages/SemesterDetail.page.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

class SemesterOverviewPage extends StatefulWidget {
  SemesterOverviewPage({Key key}) : super(key: key);

  @override
  _SemesterOverviewPageState createState() => _SemesterOverviewPageState();
}

class _SemesterOverviewPageState extends State<SemesterOverviewPage> {
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
                'Noch keine Semester vorhanden..',
                style: Theme.of(context).textTheme.headline6,
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
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        // useRootNavigator: false,
                        context: context,
                        builder: (context) {
                          return SemesterDetailPage();
                        });
                  },
                  child: Text(
                    'Semester hinzufügen',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
