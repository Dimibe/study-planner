import 'package:json_annotation/json_annotation.dart';
import 'package:study_planner/models/Semester.dart';

part 'StudyPlan.g.dart';

@JsonSerializable(explicitToJson: true)
class StudyPlan {
  String uni;
  String studyName;
  String semesterCount;
  String creditsMain;
  String creditsOther;
  List<Semester> semester = [];

  StudyPlan(
      [this.uni,
      this.studyName,
      this.semesterCount,
      this.creditsMain,
      this.creditsOther,
      this.semester]);

  factory StudyPlan.fromJson(Map<String, dynamic> json) =>
      _$StudyPlanFromJson(json);

  Map<String, dynamic> toJson() => _$StudyPlanToJson(this);
}
