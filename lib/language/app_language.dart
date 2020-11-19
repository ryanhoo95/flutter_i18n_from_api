import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale(LANG_EN);

  static const String LANG_EN = 'en';
  static const String LANG_MS = 'ms';
  static const String LANG_ZH = 'zh';
  final String keyLanguageCode = 'language_code';
  static String currentLanguageCode = LANG_EN;

  Locale get appLocale => _appLocale ?? Locale(LANG_EN);

  // return the locale based on the language code stored in shared pref
  // return locale en by default
  Future<Locale> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.get(keyLanguageCode) == null) {
      _appLocale = Locale(LANG_EN);
    } else {
      _appLocale = Locale(prefs.get(keyLanguageCode));
    }

    return _appLocale;
  }

  // return the language code stored in shared pref
  // return en by default
  Future<String> fetchLanguageCode() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.get(keyLanguageCode) == null) {
      return LANG_EN;
    } else {
      currentLanguageCode = prefs.get(keyLanguageCode);
      return currentLanguageCode;
    }
  }

  // switch language and notify the app for updating the label
  void changeLanguage(String langCode) async {
    var prefs = await SharedPreferences.getInstance();

    _appLocale = Locale(langCode);
    await prefs.setString(keyLanguageCode, langCode);
    currentLanguageCode = langCode;
    notifyListeners();
  }
}
