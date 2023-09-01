import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/settings/settings_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helpers.dart';
@GenerateNiceMocks([MockSpec<SettingsRepository>(), MockSpec<InfoService>()])
import 'settings_view_model_test.mocks.dart';

void main() async {
  final l10n = await setupLocalizations();

  group("SettingsViewModel", () {
    const String appVersion = "0.0.0";
    late SettingsViewModel viewModel;

    final settingsRepositoryMock = MockSettingsRepository();
    final infoServiceMock = MockInfoService();

    setUpAll(() {
      locator.registerSingleton<SettingsRepository>(settingsRepositoryMock);
      locator.registerSingleton<InfoService>(infoServiceMock);
    });

    setUp(() {
      viewModel = SettingsViewModel(l10n: l10n);
      when(settingsRepositoryMock.themeMode).thenReturn(ThemeMode.system);
      when(infoServiceMock.appVersion).thenReturn(appVersion);
    });

    tearDown(() {
      reset(settingsRepositoryMock);
      reset(infoServiceMock);
    });

    tearDownAll(() {
      unregister<SettingsRepository>();
      unregister<InfoService>();
    });

    test("Should retrieve the application version from the InfoService", () {
      expect(viewModel.version, appVersion);
      verify(infoServiceMock.appVersion);
      verifyNoMoreInteractions(infoServiceMock);
    });

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
}
