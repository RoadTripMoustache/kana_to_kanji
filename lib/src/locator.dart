import 'package:get_it/get_it.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/interfaces/groups_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/interfaces/kana_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/mobile/groups_repository.dart' // Default version
    if (dart.library.html) 'package:kana_to_kanji/src/core/repositories/web/groups_repository.dart'; // Web version
import 'package:kana_to_kanji/src/core/repositories/mobile/kana_repository.dart' // Default version
    if (dart.library.html) 'package:kana_to_kanji/src/core/repositories/web/kana_repository.dart'; // Web version
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/services/database_service.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/core/services/preferences_service.dart';
import 'package:logger/logger.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Logger>(() => Logger());
  locator.registerSingletonAsync<DatabaseService>(() async {
    final instance = DatabaseService();

    await instance.initialize([Group.tableCreate, Kana.tableCreate], []);

    return instance;
  });
  locator.registerLazySingleton<PreferencesService>(() => PreferencesService());
  locator.registerLazySingleton<IGroupsRepository>(() => GroupsRepository());
  locator.registerLazySingleton<IKanaRepository>(() => KanaRepository());
  locator.registerSingleton<SettingsRepository>(SettingsRepository());
  locator.registerSingletonAsync<InfoService>(() async {
    final instance = InfoService();
    await instance.initialize();
    return instance;
  });
}
