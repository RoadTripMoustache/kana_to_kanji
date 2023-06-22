import 'package:get_it/get_it.dart';
import 'package:kana_to_kanji/src/quiz/repositories/kana_repository.dart';
import 'package:logger/logger.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Logger>(() => Logger());
  locator.registerLazySingleton<KanaRepository>(() => KanaRepository());
}
