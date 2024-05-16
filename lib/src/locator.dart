import "package:flutter/foundation.dart" show kIsWeb;
import "package:get_it/get_it.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/dataloaders/group_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/kana_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/groups_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/core/services/info_service.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/core/services/sync_service.dart";
import "package:logger/logger.dart";
import "package:path_provider/path_provider.dart";

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerLazySingleton<Logger>(Logger.new)

    // Services
    ..registerSingleton<DialogService>(DialogService())
    ..registerLazySingleton<PreferencesService>(PreferencesService.new)
    ..registerSingletonAsync<ApiService>(() async => ApiService())
    ..registerSingletonAsync<InfoService>(() async {
      final instance = InfoService();
      await instance.initialize();
      return instance;
    })

    // Isar
    ..registerSingletonAsync<Isar>(() async {
      await Isar.initialize();
      final String directory = kIsWeb
          ? Isar.sqliteInMemory
          : (await getApplicationSupportDirectory()).path;

      final isar = Isar.open(
        schemas: [GroupSchema, KanaSchema, KanjiSchema, VocabularySchema],
        directory: directory,
        engine: IsarEngine.sqlite,
      );

      return isar;
    })

    // Repositories
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

    // Data Loaders
    ..registerSingletonAsync<SyncService>(() async {
      final instance = SyncService();

      // Get the sync data to know which calls need to be done.
      final sync = await instance.getSyncData();

      // - Group
      locator
        ..registerSingletonAsync<GroupDataLoader>(() async {
          final instance = GroupDataLoader();
          if (sync.groupsFlag) {
            // Load the collection only if required
            await instance.loadCollection(forceReload:sync.forceReload);
          }
          return instance;
        }, dependsOn: [Isar])

        // - Kana
        ..registerSingletonAsync<KanaDataLoader>(() async {
          final instance = KanaDataLoader();
          if (sync.kana) {
            // Load the collection only if required
            await instance.loadCollection(forceReload:sync.forceReload);
          }
          return instance;
        }, dependsOn: [Isar])

        // - Kanji
        ..registerSingletonAsync<KanjiDataLoader>(() async {
          final instance = KanjiDataLoader();
          if (sync.kanji) {
            // Load the collection only if required
            await instance.loadCollection(forceReload:sync.forceReload);
          }
          return instance;
        }, dependsOn: [Isar])

        // - Vocabulary
        ..registerSingletonAsync<VocabularyDataLoader>(() async {
          final instance = VocabularyDataLoader();
          if (sync.vocabulary) {
            // Load the collection only if required
            await instance.loadCollection(forceReload:sync.forceReload);
          }
          return instance;
        }, dependsOn: [Isar])

        // - Clean up
        ..registerSingletonAsync<CleanUpService>(() async {
          final instance = CleanUpService();
          if (sync.cleanup) {
            // Execute the clean up, only if required
            await instance.executeCleanUp(forceReload: sync.forceReload);
          }
          return instance;
        }, dependsOn: [
          Isar,
          ApiService,
        ]);

      return instance;
    }, dependsOn: [ApiService, Isar]);
}
