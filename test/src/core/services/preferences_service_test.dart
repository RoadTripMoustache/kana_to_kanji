import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  SharedPreferences? sharedPreferences;

  PreferencesService? service;

  SharedPreferences.setMockInitialValues({});

  group("PreferencesService", () {
    setUp(() async {
      sharedPreferences = await SharedPreferences.getInstance();

      service = PreferencesService();
    });

    group("setters", () {
      test("setBool", () async {
        expect(await service!.setBool(PreferenceFlags.themeMode, true), isTrue);
        expect(sharedPreferences!.getBool(PreferenceFlags.themeMode.toString()),
            isTrue);
      });

      test("setString", () async {
        expect(await service!.setString(PreferenceFlags.themeMode, "Test"),
            isTrue);
        expect(
            sharedPreferences!.getString(PreferenceFlags.themeMode.toString()),
            "Test");
      });

      test("setInt", () async {
        expect(await service!.setInt(PreferenceFlags.themeMode, 1), isTrue);
        expect(
            sharedPreferences!.getInt(PreferenceFlags.themeMode.toString()), 1);
      });

      test("setDateTime", () async {
        expect(
            await service!
                .setDateTime(PreferenceFlags.themeMode, DateTime(2000, 01, 02)),
            isTrue);
        expect(
            sharedPreferences!.getString(PreferenceFlags.themeMode.toString()),
            DateTime(2000, 01, 02).toIso8601String());
      });
    });

    test("clear", () async {
      SharedPreferences.setMockInitialValues(
          {PreferenceFlags.themeMode.toString(): true});

      expect(await service!.getBool(PreferenceFlags.themeMode), isTrue);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      expect(await service!.getBool(PreferenceFlags.themeMode), null);
    });

    group("getters", () {
      test("getBool", () async {
        SharedPreferences.setMockInitialValues(
            {PreferenceFlags.themeMode.toString(): true});

        expect(await service!.getBool(PreferenceFlags.themeMode), isTrue);
      });

      test("getString", () async {
        SharedPreferences.setMockInitialValues(
            {PreferenceFlags.themeMode.toString(): "Test"});

        expect(await service!.getString(PreferenceFlags.themeMode), "Test");
      });

      test("getInt", () async {
        SharedPreferences.setMockInitialValues(
            {PreferenceFlags.themeMode.toString(): 1});

        expect(await service!.getInt(PreferenceFlags.themeMode), 1);
      });

      test("getDateTime", () async {
        SharedPreferences.setMockInitialValues({
          PreferenceFlags.themeMode.toString():
              DateTime(2000, 01, 02).toIso8601String()
        });

        expect(await service!.getDateTime(PreferenceFlags.themeMode),
            DateTime(2000, 01, 02));
      });
    });
  });
}
