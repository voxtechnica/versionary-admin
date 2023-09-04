import 'package:json_annotation/json_annotation.dart';

part 'text_value.g.dart';

@JsonSerializable()
class TextValue {
  String key;
  String value;

  TextValue({
    required this.key,
    required this.value,
  });

  factory TextValue.fromJson(Map<String, dynamic> json) =>
      _$TextValueFromJson(json);

  Map<String, dynamic> toJson() => _$TextValueToJson(this);
}
