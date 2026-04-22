import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  late SharedPreferences _prefs;
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    final savedMode = _prefs.getString(_key);
    
    if (savedMode == 'dark') return ThemeMode.dark;
    if (savedMode == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      _prefs.setString(_key, 'light');
    } else {
      state = ThemeMode.dark;
      _prefs.setString(_key, 'dark');
    }
  }
}

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
