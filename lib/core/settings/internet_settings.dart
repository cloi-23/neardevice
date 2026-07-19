import 'package:shared_preferences/shared_preferences.dart';

class InternetSettings {
  InternetSettings._();

  static const _useInternetKey = 'use_internet_connection';

  static Future<bool> isEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_useInternetKey) ?? false;
  }

  static Future<void> setEnabled(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_useInternetKey, enabled);
  }
}
