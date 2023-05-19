import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? versionID;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? givenName;
  String? familyName;
  String? email;
  String? password;
  String? passwordHash;
  String? passwordReset;
  List<String>? roles;
  String? orgID;
  String? orgName;
  String? avatarURL;
  String? websiteURL;
  String? status;

  User({
    this.id,
    this.versionID,
    this.createdAt,
    this.updatedAt,
    this.givenName,
    this.familyName,
    this.email,
    this.password,
    this.passwordHash,
    this.passwordReset,
    this.roles,
    this.orgID,
    this.orgName,
    this.avatarURL,
    this.websiteURL,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Returns true if the user has the specified role.
  bool hasRole(String role) {
    if (roles == null || roles!.isEmpty) {
      return false;
    }
    return roles!.contains(role);
  }

  /// Returns the user's full name and email address.
  @override
  String toString() {
    String name = '';
    if (givenName != null && givenName!.isNotEmpty) {
      name += givenName!;
    }
    if (familyName != null && familyName!.isNotEmpty) {
      if (name.isNotEmpty) {
        name += ' ';
      }
      name += familyName!;
    }
    String address = email == null ? '' : email!;
    if (name.isEmpty && address.isEmpty) {
      return '';
    }
    if (name.isEmpty) {
      return address;
    }
    return '$name <$address>';
  }
}
