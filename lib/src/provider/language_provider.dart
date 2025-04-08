import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:Skillify/src/data/local/cache_helper.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale;

  fetchLocale() async {
    log('local {$_appLocale}, Cache ${CacheHelper.getString(key: 'languageCode')}');
    if (CacheHelper.getString(key: 'languageCode') == '') {
      _appLocale = Locale('en');
      log('$_appLocale');
      notifyListeners();
      return _appLocale;
    }
    _appLocale = Locale(CacheHelper.getString(key: 'languageCode'));
    log('$_appLocale');
    notifyListeners();
    return _appLocale;
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await CacheHelper.saveData(key: 'languageCode', value: 'ar');
      await CacheHelper.saveData(key: 'countryCode', value: 'AE');
    } else if (type == Locale("ta")) {
      _appLocale = Locale("ta");
      await CacheHelper.saveData(key: 'languageCode', value: 'ta');
      await CacheHelper.saveData(key: 'countryCode', value: 'IN');
    } else {
      _appLocale = Locale("en");
      await CacheHelper.saveData(key: 'languageCode', value: 'en');
      await CacheHelper.saveData(key: 'countryCode', value: 'IN');
    }
    notifyListeners();
  }
}
