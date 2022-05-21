import 'package:json_annotation/json_annotation.dart';

part 'study_field.g.dart';

@JsonSerializable()
class StudyField {
  String name;
  int? credits;
  @JsonKey(defaultValue: false)
  bool countForGrade;

  StudyField(this.name, [this.credits, this.countForGrade = false]);

  factory StudyField.fromJson(Map<String, dynamic> json) =>
      _$StudyFieldFromJson(json);

  Map<String, dynamic> toJson() => _$StudyFieldToJson(this);

  @override
  String toString() => name;
}
