import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/groups_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/core/services/groups_service.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';
import 'package:kana_to_kanji/src/core/services/preferences_service.dart';
import 'package:logger/logger.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Logger>(() => Logger());

  // Services
  locator.registerLazySingleton<GroupsService>(() => GroupsService());
  locator.registerLazySingleton<KanaService>(() => KanaService());
  locator.registerLazySingleton<PreferencesService>(() => PreferencesService());
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerSingletonAsync<InfoService>(() async {
    final instance = InfoService();
    await instance.initialize();
    return instance;
  });

  // Isar
  locator.registerSingletonAsync<Isar>(() async {
    var isar = Isar.open(
      schemas: [GroupSchema, KanaSchema],
      directory: Isar.sqliteInMemory,
      engine: IsarEngine.sqlite,
    );

    return isar;
  });

  // Repositories
  locator.registerLazySingleton<GroupsRepository>(() => GroupsRepository());
  locator.registerLazySingleton<KanaRepository>(() => KanaRepository());
  locator.registerSingleton<SettingsRepository>(SettingsRepository());
}
