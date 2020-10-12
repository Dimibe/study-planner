import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyField.dart';
import 'package:study_planner/models/StudyPlan.dart';
import 'package:study_planner/utils/MathUtils.dart';

class StudyPlanUtils {
  static int creditsInSemester(Semester semester) {
    return semester.courses.map((c) => c.credits).reduce(MathUtils.sum);
  }

  static int sumOfCredits(StudyPlan studyPlan) {
    return studyPlan.semester.map(creditsInSemester).reduce(MathUtils.sum);
  }

  static double meanGrade(Semester semester) {
    var courses = semester.courses.where((c) =>
        c.grade != null &&
        !(c.studyField != null && !c.studyField.countForGrade));
    if (courses.isEmpty) {
      return null;
    }
    var sum = courses.map((c) => c.grade * c.credits).reduce(MathUtils.sum);
    var mean = sum / courses.map((c) => c.credits).reduce(MathUtils.sum);
    return mean;
  }

  static double totalMeanGrade(StudyPlan studyPlan) {
    var count = studyPlan.semester.map(meanGrade).where((g) => g != null);
    return count.isEmpty ? null : count.reduce(MathUtils.sum) / count.length;
  }

  static StudyField getStudyFieldByName(StudyPlan studyPlan, String fieldName) {
    return studyPlan.studyFields
        .firstWhere((field) => field.name == fieldName, orElse: () => null);
  }
}
