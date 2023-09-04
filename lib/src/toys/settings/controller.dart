import 'package:flutter/material.dart';
import 'package:versionary/src/api/client.dart';
import 'service.dart';

/// SettingsController is a class that many Widgets can interact with to read,
/// update, or listen to changes in user settings.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  // API Settings
  late String _hostName;
  String get hostName => _hostName;
  late String _bearerToken;
  String get bearerToken => _bearerToken;
  late ApiClient _apiClient;
  ApiClient get apiClient => _apiClient;

  /// Load the user's settings from the SettingsService.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _hostName = await _settingsService.hostName();
    if (_hostName.isEmpty || _hostName == 'api.versionary.net') {
      _hostName = 'api-staging.versionary.net';
    }
    _bearerToken = await _settingsService.bearerToken();
    _apiClient = ApiClient(hostName: _hostName, bearerToken: _bearerToken);
    await _apiClient.validateHostName();
    if (_bearerToken.isNotEmpty) {
      final isAuth = await _apiClient.validateBearerToken();
      if (!isAuth) {
        await updateBearerToken('');
      }
    }
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(_themeMode);
  }

  /// Update and persist the API Host Name based on the user's selection.
  /// The API Host Name is used to construct the base URL for API requests.
  /// The default is the Versionary staging environment.
  Future<void> updateHostName(String newHostName) async {
    if (newHostName == _hostName) return;
    _hostName = newHostName;
    _bearerToken = '';
    _apiClient.close();
    _apiClient = ApiClient(hostName: _hostName, bearerToken: _bearerToken);
    await _apiClient.validateHostName();
    await _settingsService.updateHostName(_hostName);
    await _settingsService.updateBearerToken(_bearerToken);
    notifyListeners();
  }

  /// Update and persist the API Bearer Token.
  /// The API Bearer Token is used to authenticate API requests.
  /// The default is an empty string.
  Future<void> updateBearerToken(String newBearerToken) async {
    if (newBearerToken == _bearerToken) return;
    _bearerToken = newBearerToken;
    _apiClient.bearerToken = _bearerToken;
    await _settingsService.updateBearerToken(newBearerToken);
    // notifyListeners(); // Is this needed?
  }
}
