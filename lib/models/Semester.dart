import 'package:json_annotation/json_annotation.dart';

import 'Course.dart';

part 'Semester.g.dart';

@JsonSerializable(explicitToJson: true)
class Semester {
  String name;
  @JsonKey(defaultValue: false)
  bool completed;
  @JsonKey(defaultValue: [])
  List<Course> courses;

  Semester([this.name, this.courses, this.completed]);

  factory Semester.fromJson(Map<String, dynamic> json) =>
      _$SemesterFromJson(json);

  Map<String, dynamic> toJson() => _$SemesterToJson(this);
}
