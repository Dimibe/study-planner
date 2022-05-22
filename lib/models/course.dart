import 'package:json_annotation/json_annotation.dart';

import 'study_field.dart';

part 'course.g.dart';

@JsonSerializable(explicitToJson: true)
class Course {
  String name;
  int? credits;
  double? grade;
  StudyField? studyField;

  Course(this.name, [this.credits, this.grade, this.studyField]);

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
