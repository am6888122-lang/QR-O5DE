import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LanguageOption { system, english, arabic }

class LanguageProvider extends ChangeNotifier {
  LanguageOption _language = LanguageOption.system;

  LanguageOption get language => _language;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language');
    _language = savedLanguage != null
        ? LanguageOption.values.firstWhere((e) => e.toString() == savedLanguage)
        : LanguageOption.system;
    notifyListeners();
  }

  Future<void> setLanguage(LanguageOption language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language.toString());
    notifyListeners();
  }

  Locale get currentLocale {
    switch (_language) {
      case LanguageOption.english:
        return const Locale('en');
      case LanguageOption.arabic:
        return const Locale('ar');
      case LanguageOption.system:
        return const Locale('en'); // Default to English
    }
  }
}
