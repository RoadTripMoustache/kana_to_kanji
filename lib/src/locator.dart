import "package:flutter/foundation.dart" show kIsWeb;
import "package:get_it/get_it.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/dataloaders/group_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/kana_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/user_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/user.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/groups_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/dataloader_service.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/core/services/info_service.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/core/services/sync_service.dart";
import "package:kana_to_kanji/src/core/services/toaster_service.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/core/services/user_service.dart";
import "package:logger/logger.dart";
import "package:path_provider/path_provider.dart";

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerSingletonAsync<Logger>(() async => Logger())

    //----------------------//
    // ----- Services ----- //
    //----------------------//
    ..registerSingletonWithDependencies<AuthService>(AuthService.new,
        dependsOn: [Logger])
    ..registerSingleton<DialogService>(DialogService())
    ..registerLazySingleton<PreferencesService>(PreferencesService.new)
    ..registerSingletonAsync<TokenService>(() async => TokenService())
    ..registerLazySingleton<ToasterService>(ToasterService.new)
    ..registerSingletonWithDependencies<ApiService>(ApiService.new,
        dependsOn: [TokenService])
    ..registerSingletonAsync<InfoService>(() async {
      final instance = InfoService();
      await instance.initialize();
      return instance;
    })

    // ---------------- //
    // ----- Isar ----- //
    // ---------------- //
    ..registerSingletonAsync<Isar>(() async {
      await Isar.initialize();
      final String directory = kIsWeb
          ? Isar.sqliteInMemory
          : (await getApplicationSupportDirectory()).path;

      final isar = Isar.open(
        schemas: [
          GroupSchema,
          KanaSchema,
          KanjiSchema,
          VocabularySchema,
          UserSchema
        ],
        directory: directory,
        engine: IsarEngine.sqlite,
      );

      return isar;
    })

    // ------------------------ //
    // ----- Repositories ----- //
    // ------------------------ //
    ..registerSingletonWithDependencies<GroupsRepository>(GroupsRepository.new,
        dependsOn: [Isar])
    ..registerSingletonWithDependencies<KanaRepository>(KanaRepository.new,
        dependsOn: [Isar])
    ..registerSingletonWithDependencies<KanjiRepository>(KanjiRepository.new,
        dependsOn: [Isar])
    ..registerSingletonWithDependencies<VocabularyRepository>(
        VocabularyRepository.new,
        dependsOn: [Isar])
    ..registerSingleton<SettingsRepository>(SettingsRepository())

    // ------------------------ //
    // ----- Data Loaders ----- //
    // ------------------------ //
    ..registerSingletonAsync<SyncService>(() async => SyncService(),
        dependsOn: [ApiService, Isar])

    // - Group
    ..registerSingletonAsync<GroupDataLoader>(() async => GroupDataLoader(),
        dependsOn: [ApiService, Isar])

    // - Kana
    ..registerSingletonAsync<KanaDataLoader>(() async => KanaDataLoader(),
        dependsOn: [ApiService, Isar])

    // - Kanji
    ..registerSingletonAsync<KanjiDataLoader>(() async => KanjiDataLoader(),
        dependsOn: [ApiService, Isar])

    // - Vocabulary
    ..registerSingletonAsync<VocabularyDataLoader>(
        () async => VocabularyDataLoader(),
        dependsOn: [ApiService, Isar])

    // - user
    ..registerSingletonWithDependencies<UserDataLoader>(UserDataLoader.new,
        dependsOn: [ApiService, Isar])

    // ---------------------------- //
    // ----- Services with DB ----- //
    // ---------------------------- //
    ..registerSingletonAsync<CleanUpService>(() async => CleanUpService(),
        dependsOn: [Isar, ApiService])
    ..registerSingletonWithDependencies<UserService>(UserService.new,
        dependsOn: [Isar, UserDataLoader])
    ..registerSingletonWithDependencies<UserRepository>(UserRepository.new,
        dependsOn: [Isar, UserService, AuthService])
    ..registerSingletonWithDependencies<DataloaderService>(
        DataloaderService.new,
        dependsOn: [
          SyncService,
          GroupDataLoader,
          KanaDataLoader,
          KanjiDataLoader,
          VocabularyDataLoader,
          CleanUpService,
        ]);
}
