import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/services/dialog_service.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/settings/settings_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helpers.dart';
@GenerateNiceMocks([
  MockSpec<SettingsRepository>(),
  MockSpec<DialogService>(),
  MockSpec<InfoService>()
])
import 'settings_view_model_test.mocks.dart';

void main() async {
  final l10n = await setupLocalizations();

  group("SettingsViewModel", () {
    const String appVersion = "0.0.0";
    late SettingsViewModel viewModel;

    final settingsRepositoryMock = MockSettingsRepository();
    final dialogServiceMock = MockDialogService();
    final infoServiceMock = MockInfoService();

    setUpAll(() {
      locator.registerSingleton<SettingsRepository>(settingsRepositoryMock);
      locator.registerSingleton<InfoService>(infoServiceMock);
      locator.registerSingleton<DialogService>(dialogServiceMock);
    });

    setUp(() {
      viewModel = SettingsViewModel(l10n: l10n);
      when(settingsRepositoryMock.themeMode).thenReturn(ThemeMode.system);
      when(settingsRepositoryMock.locale).thenReturn(const Locale('en'));
      when(infoServiceMock.appVersion).thenReturn(appVersion);
    });

    tearDown(() {
      reset(settingsRepositoryMock);
      reset(dialogServiceMock);
      reset(infoServiceMock);
    });

    tearDownAll(() {
      locator.unregister<SettingsRepository>(instance: settingsRepositoryMock);
      locator.unregister<InfoService>(instance: infoServiceMock);
      locator.unregister<DialogService>(instance: dialogServiceMock);
    });

    test("Should retrieve the application version from the InfoService", () {
      expect(viewModel.version, appVersion);
      verify(infoServiceMock.appVersion);
      verifyNoMoreInteractions(infoServiceMock);
    });

    group("Theme mode", () {
      test(
          "Should have selected the theme mode returned by the SettingsRepository",
          () {
        expect(viewModel.themeModeSelected, [false, true, false],
            reason: "[light: false, system: true, dark: false]");
        verify(settingsRepositoryMock.themeMode);
        verifyNoMoreInteractions(settingsRepositoryMock);
      });

      test("Should update the SettingsRepository when a new theme is selected",
          () {
        const ThemeMode newMode = ThemeMode.dark;
        when(settingsRepositoryMock.themeMode)
            .thenReturnInOrder([ThemeMode.system, newMode]);

        expect(viewModel.themeModeSelected, [false, true, false],
            reason: "[light: false, system: true, dark: false]");
        viewModel.setThemeMode(2); // 0 = light, 1 = system, 2 = dark
        expect(viewModel.themeModeSelected, [false, false, true],
            reason: "[light: false, system: false, dark: true]");

        verifyInOrder([
          settingsRepositoryMock.themeMode,
          settingsRepositoryMock.updateThemeMode(newMode),
          settingsRepositoryMock.themeMode,
        ]);
      });
    });

    group("Locale", () {
      test("Should have selected the locale returned by the SettingsRepository",
          () {
        expect(viewModel.currentLocale, const Locale("en"));
        verify(settingsRepositoryMock.locale);
        verifyNoMoreInteractions(settingsRepositoryMock);
      });

      test("Should update the SettingsRepository when a new locale is selected",
          () {
        const Locale locale = Locale("en");
        const Locale newLocale = Locale("fr");
        when(settingsRepositoryMock.locale)
            .thenReturnInOrder([locale, newLocale]);

        expect(viewModel.currentLocale, locale);
        viewModel.setLocale(newLocale);
        expect(viewModel.currentLocale, newLocale);

        verifyInOrder([
          settingsRepositoryMock.locale,
          settingsRepositoryMock.updateLocale(newLocale),
          settingsRepositoryMock.locale,
        ]);
      });
    });

    group("Feedback", () {
      test("Should call dialog service", () {
        viewModel.giveFeedback();

        verify(dialogServiceMock.showModalBottomSheet(
            isDismissible: true,
            enableDrag: false,
            showDragHandle: true,
            isScrollControlled: true,
            builder: anyNamed("builder")));
      });
    });
  });
}
