import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SettingsService stores and retrieves user settings.
/// It persists settings locally using the shared_preferences package.
class SettingsService {
  /// Load the User's preferred ThemeMode from local storage.
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('themeMode');
    switch (themeMode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }

  /// Persist a preferred ThemeMode to local storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme.toString());
  }

  /// Load the API Host Name from local storage.
  /// The default is the Versionary staging environment.
  Future<String> hostName() async {
    final prefs = await SharedPreferences.getInstance();
    final hostName = prefs.getString('hostName');
    return hostName ?? 'api-staging.versionary.net';
  }

  /// Persist a preferred API Host Name to local storage.
  Future<void> updateHostName(String hostName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hostName', hostName);
  }

  /// Load the API Bearer Token from local storage.
  /// The default is an empty string.
  Future<String> bearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final bearerToken = prefs.getString('bearerToken');
    return bearerToken ?? '';
  }

  /// Persist a preferred API Bearer Token to local storage.
  Future<void> updateBearerToken(String bearerToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bearerToken', bearerToken);
  }
}
