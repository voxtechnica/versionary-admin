import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:versionary/src/about/about.dart';
import 'package:versionary/src/api/exception.dart';
import 'package:versionary/src/api/text_value.dart';
import 'package:versionary/src/api/token.dart';
import 'package:versionary/src/api/tuid.dart';
import 'package:versionary/src/org/organization.dart';
import 'package:versionary/src/user/user.dart';

class ApiClient extends http.BaseClient {
  final http.Client _client;
  final String hostName;
  String bearerToken = '';
  User user = User();
  bool isAdmin = false;

  ApiClient({
    required this.hostName,
    this.bearerToken = '',
  }) : _client = http.Client() {
    if (hostName.isEmpty) {
      throw ArgumentError('hostName cannot be empty');
    }
  }

  /// Send the request
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    request.headers[HttpHeaders.acceptHeader] = 'application/json';
    request.headers[HttpHeaders.acceptCharsetHeader] = 'utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = 'no-cache';
    if (bearerToken != '') {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $bearerToken';
    }
    return _client.send(request);
  }

  /// Send the request and receive the response body as a JSON map.
  /// Throw an ApiException if the response is not a 200 series status code.
  /// This is used for API endpoints that return a single object.
  Future<Map<String, dynamic>> receive(http.BaseRequest request) async {
    final response = await send(request);
    final body = await response.stream.bytesToString(utf8);
    final json = jsonDecode(body);
    if (response.statusCode ~/ 100 != 2) {
      throw ApiException.fromJson(json);
    }
    return json;
  }

  /// Send the request and receive the response body as a List of JSON maps.
  /// Throw an ApiException if the response is not a 200 series status code.
  /// This is used for API endpoints that return a list of objects.
  Future<List<dynamic>> receiveList(http.BaseRequest request) async {
    final response = await send(request);
    final body = await response.stream.bytesToString(utf8);
    if (response.statusCode ~/ 100 != 2) {
      throw ApiException.fromJson(jsonDecode(body));
    }
    final List<dynamic> json = jsonDecode(body);
    return json;
  }

  /// Validate the configured API Host Name using a simple API request.
  /// Throw an ApiException if the response is not a 200 series status code.
  /// This is used to validate the API Host Name when the ApiClient is created.
  Future<void> validateHostName() async {
    final request = http.Request('GET', Uri.https(hostName, '/about'));
    final response = await send(request);
    if (response.statusCode ~/ 100 != 2) {
      throw ApiException(
        logLevel: 'ERROR',
        code: response.statusCode,
        message: 'Invalid API Host Name: $hostName',
      );
    }
  }

  /// Clear Identity resets the API Client to an anonymous state.
  void clearIdentity() {
    bearerToken = '';
    user = User();
    isAdmin = false;
  }

  /// Validate Bearer Token (which can expire)
  /// If the token is valid, set the user and return true.
  /// If the token is invalid, clear it and return false.
  Future<bool> validateBearerToken() async {
    if (bearerToken.isEmpty) {
      return false;
    }
    try {
      final token = await readToken(bearerToken);
      bearerToken = token.id;
      user = await readUser(token.userId);
      isAdmin = user.hasRole('admin');
      return true;
    } on ApiException {
      clearIdentity();
      return false;
    }
  }

  /// Login with email and password
  /// If successful, set the bearer token and return true.
  /// If unsuccessful, clear the bearer token and return false.
  Future<bool> login(String email, String password) async {
    final tokenRequest = TokenRequest(
      username: email,
      password: password,
      grantType: 'password',
    );
    try {
      final uri = Uri.https(hostName, '/login');
      final request = http.Request('POST', uri);
      request.body = jsonEncode(tokenRequest.toJson());
      final json = await receive(request);
      final LoginResponse response = LoginResponse.fromJson(json);
      bearerToken = response.token.id;
      user = response.user;
      isAdmin = user.hasRole('admin');
      return true;
    } on ApiException {
      clearIdentity();
      return false;
    }
  }

  /// Logout: delete the bearer token and clear the user
  Future<void> logout() async {
    // Make a best-effort attempt to delete the token (it may be expired)
    if (bearerToken.isNotEmpty) {
      try {
        await deleteToken(bearerToken);
      } on ApiException {
        // ignore
      }
    }
    clearIdentity();
  }

  /// Send Password Reset Token, returning an error message if unsuccessful.
  /// This is used to send a password reset email to the user.
  Future<String> sendPasswordResetToken(String email) async {
    final uri = Uri.https(hostName, '/v1/users/$email/resets');
    final request = http.Request('POST', uri);
    request.body = '{}';
    try {
      await receive(request);
      return '';
    } on ApiException catch (e) {
      return e.message;
    }
  }

  /// Reset Password, returning an error message if unsuccessful.
  /// This is used to reset the user's password.
  /// The token was previously sent to the user via email.
  Future<String> resetPassword(
      String email, String token, String password) async {
    final uri = Uri.https(hostName, '/v1/users/$email/resets/$token');
    final request = http.Request('PUT', uri);
    request.body = jsonEncode({'password': password});
    try {
      await receive(request);
      return '';
    } on ApiException catch (e) {
      return e.message;
    }
  }

  /// About: get basic information about the API, including which environment
  /// it is running in (dev, test, staging, prod).
  Future<About> about() async {
    final uri = Uri.https(hostName, '/about');
    final request = http.Request('GET', uri);
    final json = await receive(request);
    final about = About.fromJson(json);
    return about;
  }

  /// Create a Bearer Token
  Future<String> createBearerToken(String email, String password) async {
    final tokenRequest = TokenRequest(
      username: email,
      password: password,
      grantType: 'password',
    );
    final uri = Uri.https(hostName, '/v1/tokens');
    final request = http.Request('POST', uri);
    request.body = jsonEncode(tokenRequest.toJson());
    final json = await receive(request);
    final tokenResponse = TokenResponse.fromJson(json);
    return tokenResponse.accessToken;
  }

  /// Read a Token (ie. to check if it is valid)
  Future<Token> readToken(String id) async {
    final uri = Uri.https(hostName, '/v1/tokens/$id');
    final request = http.Request('GET', uri);
    final json = await receive(request);
    final token = Token.fromJson(json);
    return token;
  }

  /// Delete a Token (ie. to logout)
  /// If successful, return the deleted Token
  Future<Token> deleteToken(String id) async {
    final uri = Uri.https(hostName, '/v1/tokens/$id');
    final request = http.Request('DELETE', uri);
    final json = await receive(request);
    final token = Token.fromJson(json);
    return token;
  }

  /// Create a TUID
  Future<TUIDInfo> createTUID() async {
    final uri = Uri.https(hostName, '/v1/tuids');
    final request = http.Request('POST', uri);
    request.body = '{}';
    final json = await receive(request);
    final tuid = TUIDInfo.fromJson(json);
    return tuid;
  }

  /// Create multiple TUIDs
  Future<List<TUIDInfo>> createTUIDs(int count) async {
    final params = <String, String>{'count': count.toString()};
    final uri = Uri.https(hostName, '/v1/tuids', params);
    final request = http.Request('GET', uri);
    final list = await receiveList(request);
    final List<TUIDInfo> tuids = list.map((t) => TUIDInfo.fromJson(t)).toList();
    return tuids;
  }

  /// Parse a TUID from an ID string
  Future<TUIDInfo> parseTUID(String id) async {
    final uri = Uri.https(hostName, '/v1/tuids/$id');
    final request = http.Request('GET', uri);
    final json = await receive(request);
    final tuid = TUIDInfo.fromJson(json);
    return tuid;
  }

  /// Create an Organization
  Future<Organization> createOrganization(Organization organization) async {
    final uri = Uri.https(hostName, '/v1/organizations');
    final request = http.Request('POST', uri);
    request.body = jsonEncode(organization.toJson());
    final json = await receive(request);
    final newOrganization = Organization.fromJson(json);
    return newOrganization;
  }

  /// Read an Organization
  Future<Organization> readOrganization(String id) async {
    final uri = Uri.https(hostName, '/v1/organizations/$id');
    final request = http.Request('GET', uri);
    final json = await receive(request);
    final organization = Organization.fromJson(json);
    return organization;
  }

  /// Update an Organization
  Future<Organization> updateOrganization(Organization organization) async {
    final uri = Uri.https(hostName, '/v1/organizations/${organization.id}');
    final request = http.Request('PUT', uri);
    request.body = jsonEncode(organization.toJson());
    final json = await receive(request);
    final updatedOrganization = Organization.fromJson(json);
    return updatedOrganization;
  }

  /// Delete an Organization
  Future<Organization> deleteOrganization(String id) async {
    final uri = Uri.https(hostName, '/v1/organizations/$id');
    final request = http.Request('DELETE', uri);
    final json = await receive(request);
    final deletedOrganization = Organization.fromJson(json);
    return deletedOrganization;
  }

  /// List Organizations with optional filters and pagination, sorted by
  /// createdAt timestamp, ascending or descending. Valid params are:
  /// - reverse: most recent first (default false)
  /// - limit: maximum number of results to return (default 100)
  /// - offset: ID of the last item received (default null=first/last)
  /// - status: pending, enabled, or disabled (default null=all)
  Future<List<Organization>> listOrganizations(
      Map<String, String> params) async {
    final uri = Uri.https(hostName, '/v1/organizations', params);
    final request = http.Request('GET', uri);
    final list = await receiveList(request);
    final List<Organization> organizations =
        list.map((o) => Organization.fromJson(o)).toList();
    return organizations;
  }

  /// List all Organization names as ID/Name key/value pairs, sorted by Name
  /// This is used to populate a dropdown list of Organizations.
  Future<List<TextValue>> listOrganizationNames() async {
    final uri =
        Uri.https(hostName, '/v1/organization_names', {'sorted': 'true'});
    final request = http.Request('GET', uri);
    final list = await receiveList(request);
    final List<TextValue> organizations =
        list.map((o) => TextValue.fromJson(o)).toList();
    return organizations;
  }

  /// Create a User
  Future<User> createUser(User user) async {
    final uri = Uri.https(hostName, '/v1/users');
    final request = http.Request('POST', uri);
    request.body = jsonEncode(user.toJson());
    final json = await receive(request);
    final newUser = User.fromJson(json);
    return newUser;
  }

  /// Read a User
  Future<User> readUser(String id) async {
    final uri = Uri.https(hostName, '/v1/users/$id');
    final request = http.Request('GET', uri);
    final json = await receive(request);
    final user = User.fromJson(json);
    return user;
  }

  /// Update a User
  Future<User> updateUser(User user) async {
    final uri = Uri.https(hostName, '/v1/users/${user.id}');
    final request = http.Request('PUT', uri);
    request.body = jsonEncode(user.toJson());
    final json = await receive(request);
    final updatedUser = User.fromJson(json);
    return updatedUser;
  }

  /// Delete a User
  Future<User> deleteUser(String id) async {
    final uri = Uri.https(hostName, '/v1/users/$id');
    final request = http.Request('DELETE', uri);
    final json = await receive(request);
    final deletedUser = User.fromJson(json);
    return deletedUser;
  }

  /// List Users with optional filters and pagination, sorted by
  /// createdAt timestamp, ascending or descending. Valid params are:
  /// - reverse: most recent first (default false)
  /// - limit: maximum number of results to return (default 100)
  /// - offset: ID of the last item received (default null=first/last)
  /// - status: pending, enabled, or disabled (default null=all)
  /// - org: Organization ID (default null=all)
  /// - role: admin (default null=all)
  /// - email: email address (default null=all)
  Future<List<User>> listUsers(Map<String, String> params) async {
    final uri = Uri.https(hostName, '/v1/users', params);
    final request = http.Request('GET', uri);
    final list = await receiveList(request);
    final List<User> users = list.map((u) => User.fromJson(u)).toList();
    return users;
  }

  /// List all User names as ID/Name key/value pairs, sorted by Name
  /// This can be used to populate a dropdown list of Users.
  Future<List<TextValue>> listUserNames() async {
    final uri = Uri.https(hostName, '/v1/user_names', {'sorted': 'true'});
    final request = http.Request('GET', uri);
    final list = await receiveList(request);
    final List<TextValue> users =
        list.map((u) => TextValue.fromJson(u)).toList();
    return users;
  }
}
