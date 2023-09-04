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

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userNamesHash() => r'031033b1d9018a01e4fe56c394ae03cb9c66bea1';

/// userNamesProvider returns a list of TextValue objects containing the user's
/// ID and full name with email address.
///
/// Copied from [userNames].
@ProviderFor(userNames)
final userNamesProvider = AutoDisposeFutureProvider<List<TextValue>>.internal(
  userNames,
  name: r'userNamesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserNamesRef = AutoDisposeFutureProviderRef<List<TextValue>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
