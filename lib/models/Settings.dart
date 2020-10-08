import 'package:json_annotation/json_annotation.dart';

part 'Settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  @JsonKey(defaultValue: 9)
  int themeColorIndex;

  Settings([this.themeColorIndex = 9]);

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
