import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/AnalysisOverview.page.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';
import 'package:study_planner/pages/SemesterOverview.page.dart';
import 'package:study_planner/pages/Settings.page.dart';
import 'package:study_planner/services/NavigatorService.dart';

final GetIt getIt = GetIt.instance;

mixin Routes {
  getRoutes() {
    return [
      ListTile(
        leading: Icon(Icons.featured_play_list),
        title: Text('Allgemeine Informationen'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(GeneralInformationPage()),
        dense: true,
      ),
      ListTile(
        leading: Icon(Icons.list_alt),
        title: Text('Semester Übersicht'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(SemesterOverviewPage()),
        dense: true,
      ),
      ListTile(
        leading: Icon(Icons.analytics),
        title: Text('Semester Analyse'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(AnalysisOverviewPage()),
        dense: true,
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Einstellungen'),
        onTap: () => getIt<NavigatorService>().navigateTo(SettingsPage()),
        dense: true,
      ),
    ];
  }

  getRoutesForRow(context) {
    var color = Theme.of(context).primaryTextTheme.headline6.color;

    _getIconButton(IconData icon, String label, Widget page) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: TextButton.icon(
          icon: Icon(icon, color: color),
          label: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.normal),
          ),
          onPressed: () => getIt<NavigatorService>().navigateTo(page),
        ),
      );
    }

    return [
      _getIconButton(
          Icons.featured_play_list, 'Studium', GeneralInformationPage()),
      _getIconButton(
          Icons.list_alt, 'Semester Übersicht', SemesterOverviewPage()),
      _getIconButton(
          Icons.analytics, 'Semester Analyse', AnalysisOverviewPage()),
      _getIconButton(Icons.settings, 'Einstellungen', SettingsPage()),
    ];
  }
}
