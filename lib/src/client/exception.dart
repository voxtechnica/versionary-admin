import 'package:json_annotation/json_annotation.dart';
part 'exception.g.dart';

@JsonSerializable()
class ApiException implements Exception {
  final String logLevel;
  final int code;
  final String message;
  final String? eventID;
  final DateTime? createdAt;
  final String? uri;

  ApiException({
    required this.logLevel,
    required this.code,
    required this.message,
    this.eventID,
    this.createdAt,
    this.uri,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) =>
      _$ApiExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$ApiExceptionToJson(this);

  @override
  String toString() {
    String e = 'ApiException';
    if (eventID != null && eventID!.isNotEmpty) {
      e += ' $eventID';
    }
    return '$e $logLevel $code $message';
  }
}
