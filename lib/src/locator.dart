import "package:flutter/foundation.dart" show kIsWeb;
import "package:get_it/get_it.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
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
import "package:kana_to_kanji/src/core/services/dataloader_service.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/core/services/info_service.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
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
    ..registerSingleton<ToasterService>(ToasterService())
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

    // ---------------------------- //
    // ----- Services with DB ----- //
    // ---------------------------- //
    ..registerSingletonWithDependencies<UserService>(UserService.new,
        dependsOn: [Isar])
    ..registerSingletonWithDependencies<UserRepository>(UserRepository.new,
        dependsOn: [Isar, UserService, AuthService])
    ..registerLazySingleton<DataloaderService>(DataloaderService.new);
}
