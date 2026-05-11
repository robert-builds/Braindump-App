import 'dart:io';

import 'package:braindump_app/models/thought_entry.dart';
import 'package:braindump_app/services/app_paths.dart';
import 'package:braindump_app/services/thought_repository.dart';
import 'package:braindump_app/services/voice_capture_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('saves transcript and deletes temporary audio', () async {
    final tempDir = await Directory.systemTemp.createTemp('braindump_voice_test_');
    addTearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    final paths = AppPaths(tempDir);
    await paths.ensureCreated();
    final audioFile = File('${paths.audioTemp.path}/recording.wav');
    await audioFile.writeAsBytes(<int>[1, 2, 3]);

    final service = VoiceCaptureService(
      paths: paths,
      repository: ThoughtRepository(paths),
    );

    final entry = await service.saveTranscriptAndDeleteAudio(
      audioFile: audioFile,
      transcript: 'Transcribed locally',
    );

    expect(entry.source, ThoughtSource.voice);
    expect(await audioFile.exists(), isFalse);
  });
}
