import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class VoiceNoteAudioService {
  VoiceNoteAudioService._();

  static Directory? _cachedVoiceNotesDir;

  /// Gets the directory where local voice note files are permanently stored.
  static Future<Directory> _getVoiceNotesDirectory() async {
    if (_cachedVoiceNotesDir != null && await _cachedVoiceNotesDir!.exists()) {
      return _cachedVoiceNotesDir!;
    }
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory voiceNotesDir = Directory('${appDocDir.path}/voice_notes');
    if (!await voiceNotesDir.exists()) {
      await voiceNotesDir.create(recursive: true);
    }
    _cachedVoiceNotesDir = voiceNotesDir;
    return voiceNotesDir;
  }

  /// Caches a freshly recorded voice note file to permanent local storage
  /// associated with both the assigned voiceNoteId and the server audioPath filename.
  static Future<void> cacheLocalRecording({
    required String voiceNoteId,
    required String? audioPath,
    required String recordedFilePath,
  }) async {
    try {
      final File sourceFile = File(recordedFilePath);
      if (!await sourceFile.exists()) return;

      final Directory dir = await _getVoiceNotesDirectory();

      // 1. Save with ID
      final String idFileName = '$voiceNoteId.m4a';
      final File idTargetFile = File('${dir.path}/$idFileName');
      await sourceFile.copy(idTargetFile.path);

      // 2. Also save with server filename if available (e.g. GUID.m4a)
      if (audioPath != null && audioPath.trim().isNotEmpty) {
        final String serverFileName = _extractFileName(audioPath);
        if (serverFileName.isNotEmpty && serverFileName != idFileName) {
          final File serverTargetFile = File('${dir.path}/$serverFileName');
          await sourceFile.copy(serverTargetFile.path);
        }
      }
    } catch (e) {
      debugPrint('VoiceNoteAudioService: failed to cache local recording: $e');
    }
  }

  /// Finds if a local copy of this voice note exists on the device.
  static Future<File?> getLocalAudioFile({
    required String voiceNoteId,
    required String? audioPath,
  }) async {
    try {
      final Directory dir = await _getVoiceNotesDirectory();

      // 1. Check by ID in permanent storage
      final File byId = File('${dir.path}/$voiceNoteId.m4a');
      if (await byId.exists() && await byId.length() > 0) {
        return byId;
      }

      // 2. Check by server basename in permanent storage
      if (audioPath != null && audioPath.trim().isNotEmpty) {
        final String serverFileName = _extractFileName(audioPath);
        if (serverFileName.isNotEmpty) {
          final File byName = File('${dir.path}/$serverFileName');
          if (await byName.exists() && await byName.length() > 0) {
            return byName;
          }
        }
      }

      // 3. Fallback: check temporary directory for any recent matching recording
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFileById = File('${tempDir.path}/$voiceNoteId.m4a');
      if (await tempFileById.exists() && await tempFileById.length() > 0) {
        return tempFileById;
      }
    } catch (e) {
      debugPrint('VoiceNoteAudioService: getLocalAudioFile error: $e');
    }
    return null;
  }

  /// Resolves an audio Source (prefers local file if available, falls back to UrlSource).
  static Future<Source> resolveSource({
    required String voiceNoteId,
    required String? audioPath,
    required String audioUrl,
  }) async {
    final File? localFile = await getLocalAudioFile(
      voiceNoteId: voiceNoteId,
      audioPath: audioPath,
    );

    if (localFile != null) {
      return DeviceFileSource(localFile.path);
    }

    return UrlSource(audioUrl);
  }

  static String _extractFileName(String path) {
    final String clean = path.replaceAll('\\', '/');
    final int lastSlash = clean.lastIndexOf('/');
    if (lastSlash != -1 && lastSlash < clean.length - 1) {
      return clean.substring(lastSlash + 1);
    }
    return clean;
  }
}
