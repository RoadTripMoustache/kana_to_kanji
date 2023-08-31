import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/preference_flags.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/services/preferences_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers.dart';
@GenerateNiceMocks([MockSpec<PreferencesService>()])
import 'settings_repository_test.mocks.dart';

void main() {
  group("SettingsRepository", () {
    late SettingsRepository repository;

    final preferencesServiceMock = MockPreferencesService();

    setUpAll(() {
      locator.registerSingleton<PreferencesService>(preferencesServiceMock);
    });

    setUp(() {
      repository = SettingsRepository();
    });

    tearDown(() {
      reset(preferencesServiceMock);
    });

    tearDownAll(() {
      unregister<PreferencesService>();
    });

    group("Theme mode", () {
      group("get", () {
        test("should return the ThemeMode.system when no theme is found",
            () async {
          await repository.loadSettings();

          expect(repository.themeMode, ThemeMode.system,
              reason:
                  "No theme mode is saved or the saved one is invalid, instead should return system.");
          verify(preferencesServiceMock.getString(PreferenceFlags.themeMode));
        });

        test("should return the saved theme mode", () async {
          when(preferencesServiceMock.getString(PreferenceFlags.themeMode))
              .thenAnswer((_) async => ThemeMode.dark.toString());
          await repository.loadSettings();

          expect(repository.themeMode, ThemeMode.dark);
          verify(preferencesServiceMock.getString(PreferenceFlags.themeMode));
        });
      });

      group("update", () {
        int fired = 0;

        void listener() {
          fired++;
        }

        setUp(() {
          fired = 0;
          repository.addListener(listener);
        });

        tearDown(() => repository.removeListener(listener));

        test("should update the theme and notify listener", () async {
          await repository.loadSettings();

          const newMode = ThemeMode.dark;

          expect(repository.themeMode, ThemeMode.system,
              reason:
                  "No theme mode is saved or the saved one is invalid, instead should return system.");
          await repository.updateThemeMode(newMode);
          expect(repository.themeMode, newMode,
              reason: "Mode should have been updated");
          expect(fired, 2,
              reason:
                  "Listener should have been notified 2 times, during loadSettings and updateThemeMode");
          verifyInOrder([
            preferencesServiceMock.getString(PreferenceFlags.themeMode),
            preferencesServiceMock.setString(
                PreferenceFlags.themeMode, newMode.toString())
          ]);
          verifyNoMoreInteractions(preferencesServiceMock);
        });

        test("should not update the theme", () async {
          await repository.loadSettings();

          const newMode = ThemeMode.system;

          expect(repository.themeMode, ThemeMode.system,
              reason:
              "No theme mode is saved or the saved one is invalid, instead should return system.");
          await repository.updateThemeMode(newMode);
          expect(repository.themeMode, ThemeMode.system,
              reason: "Mode should not have change");
          expect(fired, 1,
              reason:
              "Listener should have been notified 1 time during loadSettings");
          verifyInOrder([
            preferencesServiceMock.getString(PreferenceFlags.themeMode),
          ]);
          verifyNoMoreInteractions(preferencesServiceMock);
        });
      });
    });
  });
}
