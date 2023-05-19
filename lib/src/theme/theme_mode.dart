import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  /// Load the user's preferred ThemeMode from local storage.
  @override
  FutureOr<ThemeMode> build() async {
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

  /// Update the user's preferred ThemeMode, storing it locally.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme.toString());
    state = AsyncValue.data(theme);
  }

  /// Toggle between light and dark mode, based on the current brightness.
  Future<void> toggle(Brightness current) async {
    if (current == Brightness.dark) {
      await updateThemeMode(ThemeMode.light);
    } else {
      await updateThemeMode(ThemeMode.dark);
    }
  }

  /// Set the user's preferred ThemeMode to dark.
  Future<void> setDark() async {
    await updateThemeMode(ThemeMode.dark);
  }

  /// Set the user's preferred ThemeMode to light.
  Future<void> setLight() async {
    await updateThemeMode(ThemeMode.light);
  }

  /// Set the user's preferred ThemeMode to system.
  Future<void> setSystem() async {
    await updateThemeMode(ThemeMode.system);
  }
}
