import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ThemeMode get theme => _theme;

  Color _primaryColor = Color(0xFF4CAF50);
  Color get primaryColor => _primaryColor;

  void changeTheme() async {
    if (CacheHelper.getString(key: 'theme') == 'Light') {
      _theme = ThemeMode.light;
      notifyListeners();
    } else if (CacheHelper.getString(key: 'theme') == 'Dark') {
      _theme = ThemeMode.dark;
      notifyListeners();
    } else {
      _theme = ThemeMode.system;
      notifyListeners();
    }
  }

  void changeColorScheme() async {
    String? color = CacheHelper.getString(key: 'colorScheme');
    if (color == 'Teal Green') {
      _primaryColor = Color(0xFF13584A);
    } else if (color == 'Green') {
      _primaryColor = Color.fromARGB(255, 9, 75, 9);
    } else {
      _primaryColor = Color(0xFF1552B2);
    }
    notifyListeners();
  }
}
