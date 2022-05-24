import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/study_paln_analysis.dart';
import '../models/semester.dart';
import '../services/navigator.service.dart';
import '../services/study_plan.service.dart';
import '../utils/study_plan_utils.dart';
import '../widgets/sp_barchart.dart';
import '../widgets/sp_dialog.dart';
import '../widgets/common/cw_app_state.dart';
import '../widgets/common/cw_button.dart';
import '../widgets/common/cw_card.dart';
import 'general_information.page.dart';

class AnalysisOverviewPage extends StatefulWidget {
  const AnalysisOverviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _AnalysisOverviewPageState();
}

class _AnalysisOverviewPageState extends CWState<AnalysisOverviewPage> {
  StudyPlanAnalysis? studyPlanInfo;

  @override
  void initState() {
    super.initState();
    GetIt.I<StudyPlanService>().loadStudyPlan().then((studyPlan) {
      if (studyPlan != null) {
        setState(() {
          studyPlanInfo = StudyPlanAnalysis(studyPlan);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPDialog(
      header: 'header.analysisOverview',
      content: () {
        var info = studyPlanInfo;
        if (info == null) {
          return <Widget>[
            Text(
              'text.createStudyPlanFirst',
              style: Theme.of(context).textTheme.headline6,
            ),
            CWButton(
              label: 'button.label.goToStudyPlan',
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              onPressed: () => GetIt.I<NavigatorService>()
                  .navigateTo(const GeneralInformationPage()),
            ),
          ];
        }
        return [
          Wrap(
            children: [
              CWCard(
                title: 'label.credits',
                trailingTitle:
                    '${((info.plannedCreditsNow / info.creditsTotal) * 100).toStringAsFixed(2)}%',
                subTitle: 'text.totalCredits::${info.creditsTotal}',
                info: [
                  'text.alreadyArchived::${info.plannedCreditsNow}::${info.creditsNow}',
                  'text.archivedInMainPlan::${info.creditsInMainPlan}::${info.plannedCreditsInMainPlan}',
                  'text.averageCreditsInSemester::${info.plannedMeanCreditsSemster}',
                  'text.currentlyNeededCreditsInSemester::${info.plannedCreditsPerSemester.toStringAsFixed(2)}',
                ],
                height: 310,
                color: Colors.blue,
              ),
              CWCard(
                title: 'label.grade',
                trailingTitle: info.meanGrade?.toStringAsFixed(2) ?? '-',
                info: [
                  'text.bestPossibleGrade::${info.bestPossibleGrade}',
                  'text.plannedBestPossibleGrade::${info.plannedBestPossibleGrade}',
                ],
                height: 310,
                color: Colors.green,
              ),
              CWCard(
                title: 'label.semester',
                trailingTitle:
                    'text.currentSemester::${info.semesterCount - info.plannedOpenSemester + 1}',
                subTitle: 'text.goalSemester::${info.semesterCount}',
                info: [
                  'text.openSemester::${info.plannedOpenSemester}',
                  if (info.plannedSemesterOpen < double.infinity)
                    'text.remainingSemester::${info.plannedSemesterOpen.toStringAsFixed(1)}',
                  'text.plannedRemainingSemester::${info.semesterOpen.toStringAsFixed(1)}',
                ],
                height: 310,
                color: Colors.red,
              ),
            ],
          ),
          Wrap(
            children: [
              SPBarChart<Semester>(
                id: 'credits',
                title: 'title.credits',
                data: info.semester,
                domainFn: (s, _) => s.name,
                measureFn: (s, _) => StudyPlanUtils.creditsInSemester(s),
                average: info.meanCreditsSemster,
              ),
              SPBarChart<Semester>(
                id: 'courses',
                title: 'title.gpa',
                data: info.semester,
                domainFn: (s, _) => s.name,
                labelFn: (s, _) =>
                    StudyPlanUtils.semesterMeanGrade(s)!.toStringAsFixed(2),
                measureFn: (s, _) => StudyPlanUtils.semesterMeanGrade(s),
                average: info.meanGrade,
              ),
            ],
          ),
        ];
      },
    );
  }
}
