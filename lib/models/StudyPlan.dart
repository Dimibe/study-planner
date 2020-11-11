import 'package:json_annotation/json_annotation.dart';
import 'package:study_planner/models/Semester.dart';
import 'package:study_planner/models/StudyField.dart';

part 'StudyPlan.g.dart';

@JsonSerializable(explicitToJson: true)
class StudyPlan {
  String uni;
  String studyName;
  int semesterCount;
  int creditsMain;
  int creditsOther;
  @JsonKey(defaultValue: const [])
  List<StudyField> studyFields;
  @JsonKey(defaultValue: const [])
  List<Semester> semester;

  StudyPlan(
      [this.uni,
      this.studyName,
      this.semesterCount,
      this.creditsMain,
      this.creditsOther,
      this.studyFields,
      this.semester]) {
    if (studyFields == null || studyFields.isEmpty) {
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
