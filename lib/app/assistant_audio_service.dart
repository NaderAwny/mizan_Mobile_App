import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AssistantAudioService {
  Future<void> preload();
  Future<void> playWelcome({VoidCallback? onComplete});
  Future<void> stopWelcome();
  Future<void> playListeningEnd();
  Future<void> playError();
  Future<void> setSoundsEnabled(bool enabled);
  Future<bool> isSoundsEnabled();
  Future<void> setVibrationEnabled(bool enabled);
  Future<bool> isVibrationEnabled();
  void dispose();
}

@LazySingleton(as: AssistantAudioService)
class AssistantAudioServiceImpl implements AssistantAudioService {
  final SharedPreferences _prefs;
  final AudioPlayer _welcomePlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();

  bool _isPreloaded = false;
  bool _welcomePrepared = false;
  bool _soundsEnabled = true;
  bool _vibrationEnabled = true;
  Future<void>? _preloadFuture;
  StreamSubscription<void>? _welcomeCompleteSub;

  static const String _keySounds = 'assistant_sounds_enabled';
  static const String _keyVibration = 'assistant_vibration_enabled';

  AssistantAudioServiceImpl(this._prefs);

  @override
  Future<void> preload() {
    if (_isPreloaded) return Future<void>.value();
    return _preloadFuture ??= _doPreload();
  }

  Future<void> _doPreload() async {
    final Stopwatch sw = Stopwatch()..start();
    try {
      _soundsEnabled = _prefs.getBool(_keySounds) ?? true;
      _vibrationEnabled = _prefs.getBool(_keyVibration) ?? true;

      // Do NOT set isSpeakerphoneOn: true on Android normal mode (causes Permission Denial
      // without MODIFY_AUDIO_SETTINGS and breaks audio routing). Default loudspeaker works cleanly.
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.speech,
            usageType: AndroidUsageType.assistant,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playAndRecord,
            options: const <AVAudioSessionOptions>{
              AVAudioSessionOptions.duckOthers,
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
        ),
      );

      await Future.wait(<Future<void>>[
        _welcomePlayer.setPlayerMode(PlayerMode.mediaPlayer),
        _welcomePlayer.setReleaseMode(ReleaseMode.stop),
        _errorPlayer.setPlayerMode(PlayerMode.mediaPlayer),
        _errorPlayer.setReleaseMode(ReleaseMode.stop),
      ]);

      await Future.wait(<Future<void>>[
        _welcomePlayer.setSource(AssetSource('audio/welcome.mp3')).then((_) {
          _welcomePrepared = true;
        }),
        _errorPlayer.setSource(AssetSource('audio/assistant_error.wav')),
      ]);

      _isPreloaded = true;
      debugPrint('[Perf] Audio preload completed in ${sw.elapsedMilliseconds}ms');
    } catch (e) {
      debugPrint('[Audio preload error]: $e');
      _preloadFuture = null;
    }
  }

  @override
  Future<void> playWelcome({VoidCallback? onComplete}) async {
    final Stopwatch sw = Stopwatch()..start();

    // Light haptic immediately instead of beep
    if (_vibrationEnabled) {
      HapticFeedback.lightImpact();
    }

    await _welcomeCompleteSub?.cancel();
    _welcomeCompleteSub = null;

    if (!_soundsEnabled) {
      debugPrint('[Perf] Sounds disabled -> welcome skipped in ${sw.elapsedMilliseconds}ms');
      onComplete?.call();
      return;
    }

    bool completed = false;
    void notifyDone() {
      if (completed) return;
      completed = true;
      _welcomeCompleteSub?.cancel();
      _welcomeCompleteSub = null;
      onComplete?.call();
    }

    if (onComplete != null) {
      _welcomeCompleteSub = _welcomePlayer.onPlayerComplete.listen((_) {
        debugPrint('[Perf] Welcome audio onPlayerComplete fired');
        notifyDone();
      });
    }

    try {
      if (_welcomePrepared) {
        if (_welcomePlayer.state == PlayerState.playing) {
          await _welcomePlayer.stop();
        }
        await _welcomePlayer.resume();
        debugPrint('[Perf] Welcome audio resume() started in ${sw.elapsedMilliseconds}ms');
      } else {
        await _welcomePlayer.play(AssetSource('audio/welcome.mp3'));
        _welcomePrepared = true;
        debugPrint('[Perf] Welcome audio fallback play() started in ${sw.elapsedMilliseconds}ms');
      }
    } catch (e) {
      debugPrint('[Audio playWelcome error]: $e');
      notifyDone();
    }
  }

  @override
  Future<void> stopWelcome() async {
    await _welcomeCompleteSub?.cancel();
    _welcomeCompleteSub = null;
    try {
      if (_welcomePlayer.state == PlayerState.playing ||
          _welcomePlayer.state == PlayerState.paused) {
        await _welcomePlayer.stop();
      }
    } catch (_) {}
  }

  @override
  Future<void> playListeningEnd() async {
    // Beep removed from path — light haptic only
    if (_vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Future<void> playError() async {
    if (_vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
    if (!_soundsEnabled) return;

    try {
      await _errorPlayer.stop();
      await _errorPlayer.resume();
    } catch (_) {
      try {
        await _errorPlayer.play(AssetSource('audio/assistant_error.wav'));
      } catch (_) {}
    }
  }

  @override
  Future<bool> isSoundsEnabled() async {
    _soundsEnabled = _prefs.getBool(_keySounds) ?? true;
    return _soundsEnabled;
  }

  @override
  Future<void> setSoundsEnabled(bool enabled) async {
    _soundsEnabled = enabled;
    await _prefs.setBool(_keySounds, enabled);
  }

  @override
  Future<bool> isVibrationEnabled() async {
    _vibrationEnabled = _prefs.getBool(_keyVibration) ?? true;
    return _vibrationEnabled;
  }

  @override
  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    await _prefs.setBool(_keyVibration, enabled);
  }

  @override
  void dispose() {
    _welcomeCompleteSub?.cancel();
    _welcomePlayer.dispose();
    _errorPlayer.dispose();
  }
}
