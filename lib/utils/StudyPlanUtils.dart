import 'package:study_planner/models/Course.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyField.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/utils/MathUtils.dart';

class StudyPlanUtils {
  static int creditsInSemester(Semester semester) {
    return semester.courses.map((c) => c.credits).reduce(MathUtils.sum);
  }

  static int sumOfCredits(StudyPlan studyPlan, {bool onlyCompleted = false}) {
    return studyPlan.semester
        .where((semester) => !onlyCompleted || semester.completed)
        .map(creditsInSemester)
        .reduce(MathUtils.sum);
  }

  static double semesterMeanGrade(Semester semester) {
    var courses = _coursesForGrading(semester);
    return _meanGrade(courses);
  }

  static double totalMeanGrade(StudyPlan studyPlan,
      {bool onlyCompleted = false}) {
    var courses = studyPlan.semester
        .where((semester) => !onlyCompleted || semester.completed)
        .expand(_coursesForGrading)
        .toList();
    return _meanGrade(courses);
  }

  static double bestPossibleMeanGrade(StudyPlan studyPlan,
      {bool onlyCompleted = false}) {
    var allCredits = studyPlan.studyFields
        .where((field) => field.countForGrade)
        .map((field) => field.credits)
        .reduce(MathUtils.sum);

    var takenCredits = studyPlan.semester
        .where((semester) => !onlyCompleted || semester.completed)
        .expand(_coursesForGrading)
        .map((c) => c.credits)
        .reduce(MathUtils.sum);

    return (takenCredits *
                totalMeanGrade(studyPlan, onlyCompleted: onlyCompleted) +
            (allCredits - takenCredits)) /
        allCredits;
  }

  static StudyField getStudyFieldByName(StudyPlan studyPlan, String fieldName) {
    return studyPlan.studyFields
        .firstWhere((field) => field.name == fieldName, orElse: () => null);
  }

  static double _meanGrade(List<Course> courses) {
    if (courses.isEmpty) {
      return null;
    }
    var sum = courses.map((c) => c.grade * c.credits).reduce(MathUtils.sum);
    var mean = sum / courses.map((c) => c.credits).reduce(MathUtils.sum);
    return mean;
  }

  static List<Course> _coursesForGrading(Semester semester) {
    return semester.courses
        .where((c) =>
            c.grade != null &&
            !(c.studyField != null && !c.studyField.countForGrade))
        .toList();
  }
}
