import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versionary/src/client/client.dart';

part 'api.g.dart';

/// Api is a wrapper around ApiClient that provides a convenient way to
/// store and retrieve the user's preferred API HostName and BearerToken.
/// It persists settings locally using the shared_preferences package.
/// It also provides a convenient way to access and update the ApiClient.
class Api {
  final String hostName;
  final String bearerToken;
  ApiClient client;

  Api({
    required this.hostName,
    required this.bearerToken,
  }) : client = ApiClient(
          hostName: hostName,
          bearerToken: bearerToken,
        );

  bool get isAuth => bearerToken.isNotEmpty;
  bool get isAdmin => client.isAdmin;
}

@riverpod
class ApiNotifier extends _$ApiNotifier {
  /// Load the user's preferred API HostName and BearerToken from local storage.
  /// The default is the Versionary staging environment and an empty token.
  /// This will also update the ApiClient.
  @override
  FutureOr<Api> build() async {
    final prefs = await SharedPreferences.getInstance();
    final hostname =
        prefs.getString('hostName') ?? 'api-staging.versionary.net';
    final bearerToken = prefs.getString('bearerToken') ?? '';
    final api = Api(
      hostName: hostname,
      bearerToken: bearerToken,
    );
    if (bearerToken.isNotEmpty) {
      await api.client.validateBearerToken();
    }
    return api;
  }

  /// Persist a preferred API Host Name to local storage.
  /// This will also update the ApiClient and clear the bearer token.
  Future<String?> updateHostName(String hostName) async {
    if (state.hasValue && state.isLoading) {
      return 'Please wait for the current request to finish.';
    } else if (state.hasValue && state.value!.hostName == hostName) {
      return 'The host name is already set to $hostName.';
    }
    // Validate the new host name
    final api = Api(
      hostName: hostName,
      bearerToken: '',
    );
    try {
      await api.client.validateHostName();
    } catch (e) {
      return e.toString();
    }
    // Update shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hostName', hostName);
    await prefs.setString('bearerToken', '');
    if (state.hasValue) {
      state.value!.client.close();
    }
    state = AsyncValue.data(api);
    return null;
  }

  /// Persist a new API Bearer Token to local storage and update the ApiClient.
  Future<void> updateBearerToken(String bearerToken) async {
    // Update shared preferences
    final prefs = await SharedPreferences.getInstance();
    final hostName =
        prefs.getString('hostName') ?? 'api-staging.versionary.net';
    await prefs.setString('bearerToken', bearerToken);
    // Update the ApiClient
    final api = Api(
      hostName: hostName,
      bearerToken: bearerToken,
    );
    // Validate the new bearer token
    if (bearerToken.isNotEmpty) {
      await api.client.validateBearerToken();
    }
    // Close the old ApiClient and set the new one
    if (state.hasValue && !state.isLoading) {
      state.value!.client.close();
    }
    state = AsyncValue.data(api);
  }

  /// Login with email and password
  /// If successful, set the bearer token and return true.
  Future<bool> login(String email, String password) async {
    if (state.hasValue && state.value != null && !state.isLoading) {
      final api = state.value!;
      final loggedIn = await api.client.login(email, password);
      final isAdmin = loggedIn && api.client.isAdmin;
      if (isAdmin) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('bearerToken', api.client.bearerToken);
      }
      state = AsyncValue.data(api);
      return isAdmin;
    }
    return false;
  }

  /// Logout
  /// Clear the bearer token and return true.
  /// If the ApiClient is loading or already logged out, return false.
  Future<bool> logout() async {
    if (state.hasValue && state.value != null && !state.isLoading) {
      final api = state.value!;
      if (api.bearerToken.isEmpty && api.client.bearerToken.isEmpty) {
        return false;
      }
      await api.client.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bearerToken', '');
      state = AsyncValue.data(api);
      return true;
    }
    return false;
  }
}
