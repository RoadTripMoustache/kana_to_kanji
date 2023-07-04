import 'package:get_it/get_it.dart';
import 'package:kana_to_kanji/src/core/services/database_service.dart';
import 'package:kana_to_kanji/src/quiz/models/group.dart';
import 'package:kana_to_kanji/src/quiz/models/kana.dart';
import 'package:kana_to_kanji/src/quiz/repositories/groups_repository.dart';
import 'package:kana_to_kanji/src/core/services/database_service.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/groups_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:logger/logger.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Logger>(() => Logger());
  locator.registerSingletonAsync<DatabaseService>(() async {
    final instance = DatabaseService();

    await instance.initialize([Group.tableCreate, Kana.tableCreate], []);

    return instance;
  });
  locator.registerLazySingleton<GroupsRepository>(() => GroupsRepository());
  locator.registerLazySingleton<KanaRepository>(() => KanaRepository());
}
