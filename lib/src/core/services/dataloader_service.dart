import "package:kana_to_kanji/src/core/dataloaders/group_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/kana_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/user_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/sync_service.dart";

class DataloaderService {
  final SyncService _syncService = SyncService();
  final GroupDataLoader _groupDataLoader = GroupDataLoader();
  final KanaDataLoader _kanaDataLoader = KanaDataLoader();
  final KanjiDataLoader _kanjiDataLoader = KanjiDataLoader();
  final VocabularyDataLoader _vocabularyDataLoader = VocabularyDataLoader();
  final CleanUpService _cleanUpService = CleanUpService();
  final UserDataLoader _userDataLoader = UserDataLoader();

  /// Load all the static data from the API. But to optimise the calls,
  /// a first one is done to `GET /sync` to know which data must be updated.
  Future<void> loadStaticData() async {
    // Get the sync data to know which calls need to be done.
    final sync = await _syncService.getSyncData();

    // Load collections only if required
    if (sync.groupsFlag) {
      await _groupDataLoader.loadCollection(forceReload: sync.forceReload);
    }
    if (sync.kana) {
      await _kanaDataLoader.loadCollection(forceReload: sync.forceReload);
    }
    if (sync.kanji) {
      await _kanjiDataLoader.loadCollection(forceReload: sync.forceReload);
    }
    if (sync.vocabulary) {
      await _vocabularyDataLoader.loadCollection(forceReload: sync.forceReload);
    }

    // Execute the clean up, only if required
    if (sync.cleanup) {
      await _cleanUpService.executeCleanUp(forceReload: sync.forceReload);
    }

    await _userDataLoader.loadCollection();
  }
}
