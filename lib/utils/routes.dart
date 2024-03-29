import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../pages/analysis_overview.page.dart';
import '../pages/general_information.page.dart';
import '../pages/semester_overview.page.dart';
import '../pages/settings.page.dart';
import '../services/navigator.service.dart';
import '../widgets/common/cw_text.dart';

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

    Widget getIconButton(IconData icon, String label, Widget page) {
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
      getIconButton(Icons.featured_play_list, 'header.generalInformation',
          const GeneralInformationPage()),
      getIconButton(Icons.list_alt, 'header.semesterOverview',
          const SemesterOverviewPage()),
      getIconButton(Icons.analytics, 'header.analysisOverview',
          const AnalysisOverviewPage()),
      getIconButton(Icons.settings, 'header.settings', const SettingsPage()),
    ];
  }
}
