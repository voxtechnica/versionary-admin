import 'package:json_annotation/json_annotation.dart';
import 'package:versionary/src/client/user.dart';
part 'token.g.dart';

@JsonSerializable()
class Token {
  final String id;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String userId;
  String? email;

  Token({
    required this.id,
    required this.createdAt,
    required this.expiresAt,
    required this.userId,
    this.email,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

@JsonSerializable()
class TokenRequest {
  final String username;
  final String password;
  String grantType = 'password';

  TokenRequest({
    required this.username,
    required this.password,
    required this.grantType,
  });

  factory TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRequestToJson(this);
}

@JsonSerializable()
class TokenResponse {
  final String accessToken;
  String tokenType = 'Bearer';
  DateTime expiresAt = DateTime.now().add(const Duration(days: 30));

  TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final Token token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
