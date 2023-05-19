// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

About _$AboutFromJson(Map<String, dynamic> json) => About(
      name: json['name'] as String?,
      baseDomain: json['baseDomain'] as String?,
      gitHash: json['gitHash'] as String?,
      buildTime: json['buildTime'] == null
          ? null
          : DateTime.parse(json['buildTime'] as String),
      language: json['language'] as String?,
      environment: json['environment'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AboutToJson(About instance) => <String, dynamic>{
      'name': instance.name,
      'baseDomain': instance.baseDomain,
      'gitHash': instance.gitHash,
      'buildTime': instance.buildTime?.toIso8601String(),
      'language': instance.language,
      'environment': instance.environment,
      'description': instance.description,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aboutApiHash() => r'3478917710d9337595417bc23045190710437707';

/// aboutApiProvider is an AutoDisposeFutureProvider<About> that uses aboutApi
/// as the provider function. It is used by the AboutView widget.
///
/// Copied from [aboutApi].
@ProviderFor(aboutApi)
final aboutApiProvider = AutoDisposeFutureProvider<About>.internal(
  aboutApi,
  name: r'aboutApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aboutApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AboutApiRef = AutoDisposeFutureProviderRef<About>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
