import 'package:kana_to_kanji/src/core/constants/preference_flags.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<bool> setBool(PreferenceFlags flag, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(flag.toString(), value);
  }

  Future<bool> setString(PreferenceFlags flag, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(flag.toString(), value);
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Object?> get(PreferenceFlags flag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(flag.toString());
  }

  Future<bool> removePreferenceFlags(PreferenceFlags flag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(flag.toString());
  }

  Future<bool> setInt(PreferenceFlags flag, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(flag.toString(), value);
  }

  Future<bool> setDateTime(PreferenceFlags flag, DateTime value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(flag.toString(), value.toIso8601String());
  }

  Future<bool?> getBool(PreferenceFlags flag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(flag.toString());
  }

  Future<int?> getInt(PreferenceFlags flag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(flag.toString());
  }

  Future<String?> getString(PreferenceFlags flag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(flag.toString());
  }

  Future<DateTime?> getDateTime(PreferenceFlags flag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return DateTime.tryParse(prefs.getString(flag.toString()) ?? "");
  }
}
