import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  @JsonKey(defaultValue: 17)
  int themeColorIndex;

  @JsonKey(defaultValue: 'en')
  String locale;

  Settings({this.themeColorIndex = 17, this.locale = 'en'});

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
