import 'dart:io';

import '../models/thought_entry.dart';
import 'app_paths.dart';
import 'thought_repository.dart';

class VoiceCaptureService {
  VoiceCaptureService({required this.paths, required this.repository});

  final AppPaths paths;
  final ThoughtRepository repository;

  Future<ThoughtEntry> saveTranscriptAndDeleteAudio({
    required File audioFile,
    required String transcript,
  }) async {
    final entry = await repository.createVoiceThought(transcript);
    if (await audioFile.exists()) {
      await audioFile.delete();
    }
    return entry;
  }
}
