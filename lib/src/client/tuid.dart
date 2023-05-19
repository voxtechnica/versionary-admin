import 'package:json_annotation/json_annotation.dart';
part 'tuid.g.dart';

@JsonSerializable()
class TUIDInfo {
  final String id;
  final DateTime timestamp;
  final int entropy;

  TUIDInfo({
    required this.id,
    required this.timestamp,
    required this.entropy,
  });

  factory TUIDInfo.fromJson(Map<String, dynamic> json) =>
      _$TUIDInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TUIDInfoToJson(this);

  @override
  String toString() {
    return id;
  }
}
