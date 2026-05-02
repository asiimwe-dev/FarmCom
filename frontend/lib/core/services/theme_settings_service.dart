import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Service for persisting theme preferences to local storage
class ThemeSettingsService {
  static const String _fileName = 'theme_settings.json';

  Future<File> _getSettingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Load theme mode from storage
  Future<ThemeMode> loadThemeMode() async {
    try {
      final file = await _getSettingsFile();
      if (!await file.exists()) {
        return ThemeMode.system;
      }

      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      final themeName = json['themeMode'] as String?;

      return _themeModeFromString(themeName ?? 'system');
    } catch (e) {
      return ThemeMode.system;
    }
  }

  /// Save theme mode to storage
  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final file = await _getSettingsFile();
      final json = {
        'themeMode': _themeModeToString(mode),
      };
      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      print('Failed to save theme settings: $e');
    }
  }

  /// Convert ThemeMode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String modeString) {
    switch (modeString.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

/// Provider for settings service
final themeSettingsServiceProvider = Provider<ThemeSettingsService>((ref) {
  return ThemeSettingsService();
});
