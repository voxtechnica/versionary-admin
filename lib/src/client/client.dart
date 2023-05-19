import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:versionary/src/about/about.dart';
import 'package:versionary/src/client/exception.dart';
import 'package:versionary/src/client/token.dart';
import 'package:versionary/src/client/tuid.dart';
import 'package:versionary/src/client/user.dart';
import 'dart:convert';

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

  /// Read a User
  Future<User> readUser(String id) async {
    final uri = Uri.https(hostName, '/v1/users/$id');
    final request = http.Request('GET', uri);
    final json = await receive(request);
    final user = User.fromJson(json);
    return user;
  }
}
