import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/analysis_overview.page.dart';
import 'package:study_planner/pages/general_information.page.dart';
import 'package:study_planner/pages/semester_overview.page.dart';
import 'package:study_planner/pages/settings.page.dart';
import 'package:study_planner/services/navigator.service.dart';
import 'package:study_planner/widgets/common/cw_text.dart';

final GetIt getIt = GetIt.instance;

mixin Routes {
  List<Widget> getRoutes() {
    return [
      ListTile(
        leading: const Icon(Icons.featured_play_list),
        title: const CWText('header.generalInformation'),
        onTap: () => getIt<NavigatorService>()
            .navigateTo(const GeneralInformationPage()),
        dense: true,
      ),
      ListTile(
        leading: const Icon(Icons.list_alt),
        title: const CWText('header.semesterOverview'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(const SemesterOverviewPage()),
        dense: true,
      ),
      ListTile(
        leading: const Icon(Icons.analytics),
        title: const CWText('header.analysisOverview'),
        onTap: () =>
            getIt<NavigatorService>().navigateTo(const AnalysisOverviewPage()),
        dense: true,
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const CWText('header.settings'),
        onTap: () => getIt<NavigatorService>().navigateTo(const SettingsPage()),
        dense: true,
      ),
    ];
  }

  List<Widget> getRoutesForRow(context) {
    var color = Theme.of(context).primaryTextTheme.headline6?.color;

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
          const GeneralInformationPage()),
      _getIconButton(Icons.list_alt, 'header.semesterOverview',
          const SemesterOverviewPage()),
      _getIconButton(Icons.analytics, 'header.analysisOverview',
          const AnalysisOverviewPage()),
      _getIconButton(Icons.settings, 'header.settings', const SettingsPage()),
    ];
  }
}
