import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeModel {
  static const String _themeKey = 'app_theme';
  static const String _useSystemThemeKey = 'use_system_theme';
  
  final GetStorage _storage = GetStorage();
  
  final RxBool isDarkMode = false.obs;
  final RxBool useSystemTheme = true.obs;
  
  static final ThemeModel _instance = ThemeModel._internal();
  
  factory ThemeModel() {
    return _instance;
  }
  
  ThemeModel._internal() {
    _loadThemePreference();
  }
  
  void _loadThemePreference() {
    final bool savedUseSystemTheme = _storage.read(_useSystemThemeKey) ?? true;
    useSystemTheme.value = savedUseSystemTheme;
    
    if (savedUseSystemTheme) {
      final Brightness systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = systemBrightness == Brightness.dark;
    } else {
      final bool savedIsDarkMode = _storage.read(_themeKey) ?? false;
      isDarkMode.value = savedIsDarkMode;
    }
  }
  
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    if (!useSystemTheme.value) {
      _storage.write(_themeKey, isDarkMode.value);
    }
    _updateTheme();
  }
  
  void setDarkMode(bool value) {
    isDarkMode.value = value;
    if (!useSystemTheme.value) {
      _storage.write(_themeKey, value);
    }
    _updateTheme();
  }
  
  void setUseSystemTheme(bool value) {
    useSystemTheme.value = value;
    _storage.write(_useSystemThemeKey, value);
    
    if (value) {
      final Brightness systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = systemBrightness == Brightness.dark;
    }
    
    _updateTheme();
  }
  
  void _updateTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
  
  void listenToSystemThemeChanges() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (useSystemTheme.value) {
        final Brightness systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        isDarkMode.value = systemBrightness == Brightness.dark;
        _updateTheme();
      }
    };
  }
}