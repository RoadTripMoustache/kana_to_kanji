import "dart:async";

import "package:get_it/get_it.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/repositories/group_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/core/services/info_service.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/core/services/resources/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/resources/group_service.dart";
import "package:kana_to_kanji/src/core/services/resources/kana_service.dart";
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/resources/sync_service.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";
import "package:kana_to_kanji/src/core/services/toaster_service.dart";
import "package:logger/logger.dart";

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerLazySingleton<Logger>(Logger.new)
    //----------------------//
    // ----- Services ----- //
    //----------------------//
    ..registerSingletonAsync<AuthService>(() async => AuthService())
    ..registerSingleton<DialogService>(DialogService())
    ..registerLazySingleton<PreferencesService>(PreferencesService.new)
    ..registerSingleton<ToasterService>(ToasterService())
    ..registerSingletonWithDependencies<ApiService>(
      ApiService.new,
      dependsOn: [AuthService],
    )
    ..registerSingletonAsync<InfoService>(() async {
      final instance = InfoService();
      await instance.initialize();
      return instance;
    })
    // ---------------- //
    // ----- Data ----- //
    // ---------------- //
    ..registerSingletonAsync<DatabaseService>(() async {
      final instance = DatabaseService();

      await instance.initialize();

      return instance;
    }, dispose: (DatabaseService instance) => instance.dispose)
    ..registerSingletonWithDependencies<GroupService>(
      GroupService.new,
      dependsOn: [DatabaseService],
    )
    ..registerSingletonWithDependencies<KanaService>(
      KanaService.new,
      dependsOn: [DatabaseService],
    )
    ..registerSingletonWithDependencies<KanjiService>(
      KanjiService.new,
      dependsOn: [DatabaseService],
    )
    ..registerSingletonWithDependencies<VocabularyService>(
      VocabularyService.new,
      dependsOn: [DatabaseService],
    )
    // ------------------------ //
    // ----- Repositories ----- //
    // ------------------------ //
    ..registerLazySingleton<GroupRepository>(GroupRepository.new)
    ..registerSingletonWithDependencies<KanaRepository>(
      KanaRepository.new,
      dependsOn: [KanaService],
    )
    ..registerLazySingleton<KanjiRepository>(KanjiRepository.new)
    ..registerLazySingleton<VocabularyRepository>(VocabularyRepository.new)
    ..registerSingleton<SettingsRepository>(SettingsRepository())
    ..registerSingletonWithDependencies<UserRepository>(
      UserRepository.new,
      dependsOn: [AuthService, ApiService],
    )
    // ------------------------ //
    // ----- Data Loaders ----- //
    // ------------------------ //
    ..registerLazySingleton<CleanUpService>(CleanUpService.new)
    ..registerSingletonAsync<SyncService>(
      () async {
        final instance = SyncService();
        final AuthService authService = locator<AuthService>();

        if (await authService.getAuthToken() != null) {
          unawaited(instance.sync());
        }

        return instance;
      },
      dependsOn: [
        AuthService,
        ApiService,
        GroupService,
        KanaService,
        KanjiService,
        VocabularyService,
      ],
    );
}
