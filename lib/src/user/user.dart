import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:versionary/src/api/api.dart';
import 'package:versionary/src/api/text_value.dart';

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

  /// Returns the user's full name.
  String fullName() {
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
    return name;
  }

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

/// userNamesProvider returns a list of TextValue objects containing the user's
/// ID and full name with email address.
@riverpod
Future<List<TextValue>> userNames(UserNamesRef ref) {
  return ref.watch(apiNotifierProvider).when(
      data: (api) => api.client.listUserNames(),
      error: (e, s) => Future.value(List.empty()),
      loading: () => Future.value(List.empty()));
}
