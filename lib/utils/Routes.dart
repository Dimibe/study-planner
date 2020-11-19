import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/AnalysisOverview.page.dart';
import 'package:study_planner/pages/GeneralInformation.page.dart';
import 'package:study_planner/pages/SemesterOverview.page.dart';
import 'package:study_planner/pages/Settings.page.dart';
import 'package:study_planner/services/NavigatorService.dart';
import 'package:study_planner/widgets/common/CWText.dart';

final GetIt getIt = GetIt.instance;

mixin Routes {
  List<Widget> getRoutes() {
    return [
      ListTile(
        leading: Icon(Icons.featured_play_list),
        title: CWText('header.generalInformation'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(GeneralInformationPage()),
        dense: true,
      ),
      ListTile(
        leading: Icon(Icons.list_alt),
        title: CWText('header.semesterOverview'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(SemesterOverviewPage()),
        dense: true,
      ),
      ListTile(
        leading: Icon(Icons.analytics),
        title: CWText('header.analysisOverview'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(AnalysisOverviewPage()),
        dense: true,
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: CWText('header.settings'),
        onTap: () => getIt<NavigatorService>().navigateTo(SettingsPage()),
        dense: true,
      ),
    ];
  }

  List<Widget> getRoutesForRow(context) {
    var color = Theme.of(context).primaryTextTheme.headline6.color;

    Widget _getIconButton(IconData icon, String label, Widget page) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: TextButton.icon(
          icon: Icon(icon, color: color),
          label: CWText(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.normal),
          ),
          onPressed: () => getIt<NavigatorService>().navigateTo(page),
        ),
      );
    }

    return [
      _getIconButton(Icons.featured_play_list, 'header.generalInformation',
          GeneralInformationPage()),
      _getIconButton(
          Icons.list_alt, 'header.semesterOverview', SemesterOverviewPage()),
      _getIconButton(
          Icons.analytics, 'header.analysisOverview', AnalysisOverviewPage()),
      _getIconButton(Icons.settings, 'header.settings', SettingsPage()),
    ];
  }
}
