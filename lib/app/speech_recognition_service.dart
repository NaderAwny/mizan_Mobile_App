import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

abstract class SpeechRecognitionService {
  bool get isListening;
  Future<void> preWarm();
  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(dynamic error)? onError,
  });
  Future<List<String>> getSupportedLocales();
  Future<String> selectBestArabicLocale();
  Future<bool> startListening({
    required void Function(String partialText) onResult,
    void Function(double soundLevel)? onSoundLevel,
    String? localeId,
  });
  Future<void> stopListening();
  Future<void> cancelListening();
  void dispose();
}

@LazySingleton(as: SpeechRecognitionService)
class SpeechRecognitionServiceImpl implements SpeechRecognitionService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  String? _cachedArabicLocale;
  Future<bool>? _initFuture;

  void Function(String status)? _activeOnStatus;
  void Function(dynamic error)? _activeOnError;

  DateTime? _listenStartTime;
  bool _firstPartialLogged = false;

  @override
  bool get isListening => _speech.isListening;

  @override
  Future<void> preWarm() async {
    final Stopwatch sw = Stopwatch()..start();
    final bool ok = await initialize();
    if (ok && _cachedArabicLocale == null) {
      // Cache locale during preWarm with short timeout so tap-to-listen NEVER blocks on locales()
      try {
        _cachedArabicLocale = await selectBestArabicLocale()
            .timeout(const Duration(milliseconds: 700), onTimeout: () => 'ar_EG');
      } catch (_) {
        _cachedArabicLocale = 'ar_EG';
      }
    }
    debugPrint('[Perf] STT preWarm ok=$ok locale=$_cachedArabicLocale in ${sw.elapsedMilliseconds}ms');
  }

  @override
  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(dynamic error)? onError,
  }) async {
    if (onStatus != null) _activeOnStatus = onStatus;
    if (onError != null) _activeOnError = onError;

    // Even if already initialized (e.g. from preWarm), ensure active listeners are wired
    if (_isInitialized) {
      _speech.statusListener = _handleStatus;
      _speech.errorListener = _handleError;
      return true;
    }

    if (_initFuture != null) {
      return _initFuture!;
    }

    _initFuture = _doInitialize();
    final bool result = await _initFuture!;
    _initFuture = null;
    return result;
  }

  Future<bool> _doInitialize() async {
    try {
      _isInitialized = await _speech.initialize(
        debugLogging: kDebugMode,
        finalTimeout: const Duration(milliseconds: 800),
        onStatus: _handleStatus,
        onError: _handleError,
      );
    } catch (e) {
      debugPrint('[SpeechToText Init Exception]: $e');
      _isInitialized = false;
    }
    return _isInitialized;
  }

  void _handleStatus(String status) {
    debugPrint('[SpeechToText Status]: $status');
    _activeOnStatus?.call(status);
  }

  void _handleError(SpeechRecognitionError error) {
    debugPrint('[SpeechToText Error]: ${error.errorMsg} (${error.permanent})');
    _activeOnError?.call(error.errorMsg);
  }

  @override
  Future<List<String>> getSupportedLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    try {
      final List<LocaleName> locales = await _speech
          .locales()
          .timeout(const Duration(milliseconds: 700), onTimeout: () => <LocaleName>[]);
      return locales.map((LocaleName l) => l.localeId).toList();
    } catch (_) {
      return <String>['ar_EG', 'ar_SA'];
    }
  }

  @override
  Future<String> selectBestArabicLocale() async {
    if (_cachedArabicLocale != null) return _cachedArabicLocale!;
    final List<String> locales = await getSupportedLocales();
    for (final String id in locales) {
      final String normalized = id.toLowerCase().replaceAll('-', '_');
      if (normalized == 'ar_eg') {
        _cachedArabicLocale = id;
        return id;
      }
    }
    for (final String id in locales) {
      if (id.toLowerCase().startsWith('ar')) {
        _cachedArabicLocale = id;
        return id;
      }
    }
    _cachedArabicLocale = 'ar_EG';
    return 'ar_EG';
  }

  @override
  Future<bool> startListening({
    required void Function(String partialText) onResult,
    void Function(double soundLevel)? onSoundLevel,
    String? localeId,
  }) async {
    final Stopwatch sw = Stopwatch()..start();
    _listenStartTime = DateTime.now();
    _firstPartialLogged = false;

    if (!_isInitialized) {
      final bool initialized = await initialize();
      if (!initialized) return false;
    }

    if (_speech.isListening) {
      await cancelListening();
    }

    // Never await locales() on the critical listening path! Use pre-warmed locale or ar_EG.
    final String targetLocale = localeId ?? _cachedArabicLocale ?? 'ar_EG';

    try {
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          if (!_firstPartialLogged && _listenStartTime != null) {
            _firstPartialLogged = true;
            final int latency =
                DateTime.now().difference(_listenStartTime!).inMilliseconds;
            debugPrint('[Perf] Listen start -> First partial result: ${latency}ms ("${result.recognizedWords}")');
          }
          onResult(result.recognizedWords);
        },
        onSoundLevelChange: onSoundLevel,
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
          localeId: targetLocale,
        ),
      );
      debugPrint('[Perf] STT _speech.listen($targetLocale) called in ${sw.elapsedMilliseconds}ms');
      return true;
    } catch (e) {
      debugPrint('[SpeechToText Listen Exception]: $e');
      return false;
    }
  }

  @override
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  @override
  Future<void> cancelListening() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }

  @override
  void dispose() {
    // Keep the singleton SpeechToText initialized across screen visits; only cancel active audio.
    if (_speech.isListening) {
      _speech.cancel();
    }
  }
}
