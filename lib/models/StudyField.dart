import 'package:json_annotation/json_annotation.dart';

part 'StudyField.g.dart';

@JsonSerializable()
class StudyField {
  String name;
  int credits;
  bool countForGrade;

  StudyField([this.name, this.credits, this.countForGrade]);

  factory StudyField.fromJson(Map<String, dynamic> json) =>
      _$StudyFieldFromJson(json);

  Map<String, dynamic> toJson() => _$StudyFieldToJson(this);
}
