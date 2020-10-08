import 'package:flutter/material.dart';
import 'package:study_planner/pages/AnalysisOverview.page.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';
import 'package:study_planner/pages/SemesterOverview.page.dart';
import 'package:study_planner/pages/Settings.page.dart';

class SPDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      semanticLabel: 'Main Menu',
      child: ListView(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              height: 80,
              child: Text(
                'Main Menu',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.featured_play_list),
            title: Text('Allgemeine Informationen'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => GeneralInformationPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Semester Übersicht'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SemesterOverviewPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Semester Analyse'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AnalysisOverviewPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Einstellungen'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
