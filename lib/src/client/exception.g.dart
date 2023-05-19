// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiException _$ApiExceptionFromJson(Map<String, dynamic> json) => ApiException(
      logLevel: json['logLevel'] as String,
      code: json['code'] as int,
      message: json['message'] as String,
      eventID: json['eventID'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$ApiExceptionToJson(ApiException instance) =>
    <String, dynamic>{
      'logLevel': instance.logLevel,
      'code': instance.code,
      'message': instance.message,
      'eventID': instance.eventID,
      'createdAt': instance.createdAt?.toIso8601String(),
      'uri': instance.uri,
    };
