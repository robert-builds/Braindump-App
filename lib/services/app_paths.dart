import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppPaths {
  AppPaths(this.root);

  final Directory root;

  Directory get entries => Directory('${root.path}/entries');
  Directory get reviews => Directory('${root.path}/reviews');
  Directory get metadata => Directory('${root.path}/metadata');
  Directory get audioTemp => Directory('${root.path}/audio_temp');
  Directory get models => Directory('${root.path}/models');

  static Future<AppPaths> load() async {
    final support = await getApplicationSupportDirectory();
    return AppPaths(Directory('${support.path}/braindump'));
  }

  Future<void> ensureCreated() async {
    await Future.wait(<Future<void>>[
      entries.create(recursive: true),
      reviews.create(recursive: true),
      metadata.create(recursive: true),
      audioTemp.create(recursive: true),
      models.create(recursive: true),
    ]);
  }
}
