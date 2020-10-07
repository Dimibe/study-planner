import 'package:json_annotation/json_annotation.dart';

part 'Settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  int themeColorIndex;

  Settings([this.themeColorIndex]);

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
