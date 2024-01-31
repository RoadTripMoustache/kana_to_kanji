import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:kana_to_kanji/src/locator.dart';
import 'package:logger/logger.dart';

enum TtsState { playing, stopped, paused, continued }

const Map<String, String> _iOSVoice = {"name": "Kyoko", "gender": "female", "locale": "ja-JP"};

class TextToSpeechService {
  final Logger _logger = locator<Logger>();

  late final FlutterTts _tts;

  TtsState _currentState = TtsState.stopped;

  Future initialize() async {
    _logger.d("$runtimeType: Start initialization");
    _tts = FlutterTts();

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      // await _buildAndroidDeviceInfo(deviceInfoPlugin);
        break;
      case TargetPlatform.iOS:
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
            IosTextToSpeechAudioCategory.ambient,
            [
              IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
              IosTextToSpeechAudioCategoryOptions.mixWithOthers
            ],
            IosTextToSpeechAudioMode.voicePrompt);
        _tts.setVoice(_iOSVoice);
        break;
      default:
        break;
    }
    await _tts.awaitSpeakCompletion(true);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setLanguage("ja-JP");

    // Add handlers
    _tts.setStartHandler(() {
      _currentState = TtsState.playing;
      _logger.d("$runtimeType: speaking");
    });
    _tts.setProgressHandler((text, start, end, word) {
      _logger.d("$runtimeType: Progress: $start $end");
    });
    _tts.setCancelHandler(() {
      _currentState = TtsState.stopped;
      _logger.d("$runtimeType: cancelled");
    });
    _tts.setCompletionHandler(() {
      _currentState = TtsState.stopped;
      _logger.d("$runtimeType: stopped");
    });
    _tts.setErrorHandler((message) {
      _logger.e("$runtimeType: $message");
    });
    _logger.d("$runtimeType: Initialization finished");
  }

  /// Read the [sentence] in Japanese using device TTS.
  /// Romaji will not be read correctly, you need to be in kana and/or kanji.
  /// Default speech rate is 0.5 which is a normal talking speak.
  Future<void> speak(String sentence, [double speechRate = 0.5]) async {
    await _tts.setSpeechRate(speechRate);
    if (_currentState == TtsState.playing) {
      await _tts.stop();
    }
    _logger.i("Start speaking");
    await _tts.speak(sentence);
  }
}
