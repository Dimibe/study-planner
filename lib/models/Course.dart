import 'package:json_annotation/json_annotation.dart';

part 'Course.g.dart';

@JsonSerializable()
class Course {
  String name;
  int credits;

  Course([this.name, this.credits]);

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
