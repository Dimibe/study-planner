import '../models/course.dart';
import '../models/semester.dart';
import '../models/study_field.dart';
import '../models/study_plan.dart';
import './math_utils.dart' as reduce show sum;

class StudyPlanUtils {
  static int creditsInSemester(Semester semester, {String? fieldName}) {
    return semester.courses
        .where((course) =>
            fieldName == null || course.studyField!.name == fieldName)
        .map((c) => c.credits ?? 0)
        .reduce(reduce.sum);
  }

  static int sumOfCredits(StudyPlan studyPlan,
      {bool onlyCompleted = false, String? fieldName}) {
    var semester = studyPlan.semester
        .where((semester) => !onlyCompleted || semester.completed);
    if (semester.isEmpty) {
      return 0;
    }
    return semester
        .map((s) => creditsInSemester(s, fieldName: fieldName))
        .reduce(reduce.sum);
  }

  static double? semesterMeanGrade(Semester semester) {
    var courses = _coursesForGrading(semester);
    return _meanGrade(courses);
  }

  static double? totalMeanGrade(StudyPlan studyPlan,
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
        .map((field) => field.credits ?? 0)
        .reduce(reduce.sum);

    var semester = studyPlan.semester
        .where((semester) => !onlyCompleted || semester.completed);
    if (semester.isEmpty) return 1.0;
    var takenCredits = semester
        .expand(_coursesForGrading)
        .map((c) => c.credits ?? 0)
        .reduce(reduce.sum);

    return (takenCredits *
                totalMeanGrade(studyPlan, onlyCompleted: onlyCompleted)! +
            (allCredits - takenCredits)) /
        allCredits;
  }

  static StudyField? getStudyFieldByName(
      StudyPlan studyPlan, String fieldName) {
    var fields =
        studyPlan.studyFields.where((field) => field.name == fieldName);
    return fields.isEmpty ? null : fields.first;
  }

  static double? _meanGrade(List<Course> courses) {
    if (courses.isEmpty) {
      return null;
    }
    var sum = courses.map((c) => c.grade! * c.credits!).reduce(reduce.sum);
    var mean = sum / courses.map((c) => c.credits!).reduce(reduce.sum);
    return mean;
  }

  static List<Course> _coursesForGrading(Semester semester) {
    return semester.courses
        .where((c) =>
            c.grade != null &&
            !(c.studyField != null && !c.studyField!.countForGrade))
        .toList();
  }
}
