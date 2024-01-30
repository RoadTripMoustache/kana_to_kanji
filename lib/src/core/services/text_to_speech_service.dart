import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

enum TtsState { playing, stopped, paused, continued }

class TextToSpeechService {
  late final FlutterTts _tts;

  TtsState _currentState = TtsState.stopped;

  Future initialize() async {
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
              IosTextToSpeechAudioCategoryOptions.allowBluetooth,
              IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
              IosTextToSpeechAudioCategoryOptions.mixWithOthers
            ],
            IosTextToSpeechAudioMode.voicePrompt);
        break;
      default:
        break;
    }
    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setLanguage("ja-JP");
    // await _tts.setLanguage("en-US");

    // Add handlers
    _tts.setStartHandler(() {
      _currentState = TtsState.playing;
    });
    _tts.setCompletionHandler(() {
      _currentState = TtsState.stopped;
    });
  }

  Future<void> speak(String sentence) async {
    if (_currentState == TtsState.playing) {
      await _tts.stop();
    }
    await _tts.speak(sentence);
  }
}
