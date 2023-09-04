import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:versionary/src/api/api.dart';

part 'about.g.dart';

@JsonSerializable()
class About {
  String? name;
  String? baseDomain;
  String? gitHash;
  DateTime? buildTime;
  String? language;
  String? environment;
  String? description;

  About({
    this.name,
    this.baseDomain,
    this.gitHash,
    this.buildTime,
    this.language,
    this.environment,
    this.description,
  });

  factory About.withMessage(String message) {
    return About(
      name: 'Versionary',
      baseDomain: 'versionary.net',
      gitHash: 'unknown',
      buildTime: DateTime.now(),
      language: 'Dart',
      environment: 'unknown',
      description: message,
    );
  }

  factory About.fromJson(Map<String, dynamic> json) => _$AboutFromJson(json);

  Map<String, dynamic> toJson() => _$AboutToJson(this);
}

/// aboutApiProvider is an AutoDisposeFutureProvider<About> that uses aboutApi
/// as the provider function. It is used by the AboutView widget.
@riverpod
Future<About> aboutApi(AboutApiRef ref) {
  return ref.watch(apiNotifierProvider).when(
      data: (api) => api.client.about(),
      error: (e, s) => Future.value(About.withMessage(e.toString())),
      loading: () => Future.value(About.withMessage('Loading API Client...')));
}
