import "package:flutter/foundation.dart"
    show TargetPlatform, defaultTargetPlatform;
import "package:flutter_tts/flutter_tts.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";

enum TtsState { playing, stopped, paused, continued }

// List of the iOS voices that are "correct".
const List<Map<String, String>> _iOSVoices = [
  {
    "name": "O-ren",
    "gender": "female",
    "locale": "ja-JP",
    "quality": "default",
    "identifier": "com.apple.ttsbundle.siri_O-ren_ja-JP_compact",
  },
  {
    "name": "Hattori",
    "gender": "female",
    "locale": "ja-JP",
    "quality": "default",
    "identifier": "com.apple.ttsbundle.siri_male_ja-JP_compact",
  },
];

// List of the iOS voices that are "correct".
const List<Map<String, String>> _androidVoices = [
  {
    "features": "networkTimeoutMs\tlegacySetLanguageVoice\tnetworkRetriesCount",
    "latency": "low",
    "name": "ja-JP-language",
    "locale": "ja-JP",
    "network_required": "0",
    "quality": "high",
  },
  {
    "features": "networkTimeoutMs\tnetworkRetriesCount",
    "latency": "low",
    "name": "ja-jp-x-jab-local",
    "locale": "ja-JP",
    "network_required": "0",
    "quality": "high",
  },
  {
    "features": "networkTimeoutMs\tnetworkRetriesCount",
    "latency": "low",
    "name": "ja-jp-x-jac-local",
    "locale": "ja-JP",
    "network_required": "0",
    "quality": "high",
  },
];

class TtsService {
  final Logger _logger = locator<Logger>();

  late final FlutterTts _tts;

  late final List<Map<String, String>> _voices;

  TtsState _currentState = TtsState.stopped;

  Future initialize() async {
    _logger.d("TtsService: Start initialization");
    _tts = FlutterTts();

    // Check if Japanese language is available
    final bool isJapaneseAvailable = await _tts.isLanguageAvailable("ja-JP");

    if (!isJapaneseAvailable) {
      _logger.e("TtsService: Japanese language not available");
      return false;
    }
    await _tts.setLanguage("ja-JP");

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        await _tts.setVoice(_androidVoices.first);
        _voices = _androidVoices;
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
        await _tts.setVoice(_iOSVoices.first);
        _voices = _iOSVoices;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        _logger.e(
          "TtsService: Trying to run the app on $defaultTargetPlatform?",
        );
        throw UnimplementedError();
    }
    await _tts.awaitSpeakCompletion(true);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // Add handlers
    _tts
      ..setStartHandler(() {
        _currentState = TtsState.playing;
      })
      ..setProgressHandler((text, start, end, word) {})
      ..setCancelHandler(() {
        _currentState = TtsState.stopped;
      })
      ..setCompletionHandler(() {
        _currentState = TtsState.stopped;
      })
      ..setErrorHandler((message) {
        _logger.e("TtsService: $message");
        // TODO log error in Crashlytics
      });
    _logger.d("TtsService: Initialization finished");
  }

  int voiceCount = 0;

  /// Read the [sentence] in Japanese using device TTS.
  /// Romaji will not be read correctly, you need to be in kana and/or kanji.
  /// Default speech rate is 0.5 which is a normal talking speak.
  Future<void> speak(String sentence, [double speechRate = 0.5]) async {
    await _tts.setVoice(_voices[voiceCount]);
    voiceCount++;
    if (voiceCount >= _voices.length) {
      voiceCount = 0;
    }
    await _tts.setSpeechRate(speechRate);
    if (_currentState == TtsState.playing) {
      await _tts.stop();
    }
    _logger.i("Start speaking");
    await _tts.speak(sentence);
  }
}
