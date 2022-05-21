import 'package:json_annotation/json_annotation.dart';
import 'package:study_planner/models/semester.dart';
import 'package:study_planner/models/study_field.dart';

part 'study_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class StudyPlan {
  String? uni;
  String? studyName;
  int? semesterCount;
  int? creditsMain;
  int? creditsOther;
  @JsonKey(defaultValue: [])
  List<StudyField> studyFields;
  @JsonKey(defaultValue: [])
  List<Semester> semester;

  StudyPlan(
      [this.uni,
      this.studyName,
      this.semesterCount,
      this.creditsMain,
      this.creditsOther,
      this.studyFields = const [],
      this.semester = const []]) {
    if (studyFields.isEmpty) {
      studyFields = [
        StudyField('Hauptstudium', creditsMain, true),
        StudyField('Auflagen', creditsOther, false),
      ];
    }
    studyFields.forEach((element) {
      if (element.name == 'Hauptstudium') {
        element.credits = creditsMain;
      } else if (element.name == 'Auflagen') {
        element.credits = creditsOther;
      }
    });
  }

  factory StudyPlan.fromJson(Map<String, dynamic> json) =>
      _$StudyPlanFromJson(json);

  Map<String, dynamic> toJson() => _$StudyPlanToJson(this);
}
