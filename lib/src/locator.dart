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
import "package:kana_to_kanji/src/core/services/sync_service.dart";
import "package:kana_to_kanji/src/core/services/toaster_service.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
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
    ..registerSingletonAsync<TokenService>(() async => TokenService())
    ..registerSingleton<ToasterService>(ToasterService())
    ..registerSingletonWithDependencies<ApiService>(
      ApiService.new,
      dependsOn: [TokenService],
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
    // ------------------------ //
    // ----- Repositories ----- //
    // ------------------------ //
    ..registerSingletonWithDependencies<GroupRepository>(
      GroupRepository.new,
      dependsOn: [DatabaseService],
    )
    ..registerSingletonWithDependencies<KanaRepository>(
      KanaRepository.new,
      dependsOn: [DatabaseService],
    )
    ..registerSingletonWithDependencies<KanjiRepository>(
      KanjiRepository.new,
      dependsOn: [DatabaseService],
    )
    ..registerSingletonWithDependencies<VocabularyRepository>(
      VocabularyRepository.new,
      dependsOn: [DatabaseService],
    )
    ..registerSingleton<SettingsRepository>(SettingsRepository())
    ..registerSingletonWithDependencies<UserRepository>(
      UserRepository.new,
      dependsOn: [AuthService, ApiService],
    )
    // ------------------------ //
    // ----- Data Loaders ----- //
    // ------------------------ //
    ..registerSingletonAsync<SyncService>(() async {
      final instance = SyncService();
      final TokenService tokenService = locator<TokenService>();

      if (await tokenService.getToken() != null) {
        await instance.sync();
      }

      return instance;
    }, dependsOn: [ApiService, DatabaseService]);
}
