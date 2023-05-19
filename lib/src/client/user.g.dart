// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      versionID: json['versionID'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      givenName: json['givenName'] as String?,
      familyName: json['familyName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      passwordHash: json['passwordHash'] as String?,
      passwordReset: json['passwordReset'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      orgID: json['orgID'] as String?,
      orgName: json['orgName'] as String?,
      avatarURL: json['avatarURL'] as String?,
      websiteURL: json['websiteURL'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'versionID': instance.versionID,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'givenName': instance.givenName,
      'familyName': instance.familyName,
      'email': instance.email,
      'password': instance.password,
      'passwordHash': instance.passwordHash,
      'passwordReset': instance.passwordReset,
      'roles': instance.roles,
      'orgID': instance.orgID,
      'orgName': instance.orgName,
      'avatarURL': instance.avatarURL,
      'websiteURL': instance.websiteURL,
      'status': instance.status,
    };
