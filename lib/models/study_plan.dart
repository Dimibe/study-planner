import 'package:json_annotation/json_annotation.dart';

import 'semester.dart';
import 'study_field.dart';

part 'study_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class StudyPlan {
  String uni;
  String? studyName;
  int semesterCount;
  int creditsMain;
  int? creditsOther;
  @JsonKey(defaultValue: [])
  List<StudyField> studyFields;
  @JsonKey(defaultValue: [])
  List<Semester> semester;

  StudyPlan(
      {required this.uni,
      this.studyName,
      required this.semesterCount,
      required this.creditsMain,
      this.creditsOther,
      this.studyFields = const [],
      this.semester = const []}) {
    if (studyFields.isEmpty) {
      studyFields = [
        StudyField(
            name: 'Hauptstudium', credits: creditsMain, countForGrade: true),
        StudyField(
            name: 'Auflagen', credits: creditsOther, countForGrade: false),
      ];
    }
    for (var element in studyFields) {
      if (element.name == 'Hauptstudium') {
        element.credits = creditsMain;
      } else if (element.name == 'Auflagen') {
        element.credits = creditsOther;
      }
    }
  }

  factory StudyPlan.fromJson(Map<String, dynamic> json) =>
      _$StudyPlanFromJson(json);

  Map<String, dynamic> toJson() => _$StudyPlanToJson(this);
}
