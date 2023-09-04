import 'package:json_annotation/json_annotation.dart';

part 'organization.g.dart';

@JsonSerializable()
class Organization {
  String? id;
  String? versionID;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? status;

  Organization({
    this.id,
    this.versionID,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.status,
  });

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
