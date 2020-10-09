import 'package:json_annotation/json_annotation.dart';

part 'Course.g.dart';

@JsonSerializable()
class Course {
  String name;
  int credits;
  double grade;

  Course([this.name, this.credits, this.grade]);

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
