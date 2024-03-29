import 'package:json_annotation/json_annotation.dart';

import 'course.dart';

part 'semester.g.dart';

@JsonSerializable(explicitToJson: true)
class Semester {
  String name;
  @JsonKey(defaultValue: false)
  bool completed;
  @JsonKey(defaultValue: [])
  List<Course> courses;

  Semester(
      {required this.name, required this.courses, required this.completed});

  factory Semester.fromJson(Map<String, dynamic> json) =>
      _$SemesterFromJson(json);

  Map<String, dynamic> toJson() => _$SemesterToJson(this);
}
