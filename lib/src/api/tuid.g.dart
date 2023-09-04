// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TUIDInfo _$TUIDInfoFromJson(Map<String, dynamic> json) => TUIDInfo(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      entropy: json['entropy'] as int,
    );

Map<String, dynamic> _$TUIDInfoToJson(TUIDInfo instance) => <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'entropy': instance.entropy,
    };
