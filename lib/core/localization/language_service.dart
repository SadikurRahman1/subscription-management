

import 'package:flutter/material.dart';

import 'package:subscription_manage/core/services/storage_services/st_service.dart';

class LanguageService {
  LanguageService._internal();

  static const String languageCodeKey = "language_code_key";
  static const String languageCountryCodeKey = "language_country_code_key";
  static const Locale defaultLocale = Locale('en', 'US');


  static Future<void> saveLanguageCode({required String langKey}) async {
    await STService().saveData(languageCodeKey, langKey);
  }

  static Future<void> saveLanguageCountryCode({required String langKey}) async {
    await STService().saveData(languageCountryCodeKey, langKey);
  }

  static String? getLanguageCode() {
    return STService().getData(languageCodeKey);

  }

  static String? getLanguageCountryCode() {
    return STService().getData(languageCountryCodeKey);

  }

  static Future<void> saveLocale(Locale locale) async {
    await saveLanguageCode(langKey: locale.languageCode);
    await saveLanguageCountryCode(
      langKey: locale.countryCode ?? defaultLocale.countryCode!,
    );
  }

  static Locale? getSavedLocale() {
    final String? languageCode = getLanguageCode();
    final String? countryCode = getLanguageCountryCode();

    if (languageCode == null || countryCode == null) {
      return null;
    }

    return Locale(languageCode, countryCode);
  }
}