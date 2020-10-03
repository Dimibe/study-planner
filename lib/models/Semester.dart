import 'package:json_annotation/json_annotation.dart';

import 'Course.dart';

part 'Semester.g.dart';

@JsonSerializable(explicitToJson: true)
class Semester {
  String name;
  List<Course> courses = [];

  Semester([this.name, this.courses]);

  factory Semester.fromJson(Map<String, dynamic> json) =>
      _$SemesterFromJson(json);

  Map<String, dynamic> toJson() => _$SemesterToJson(this);
}
