import 'dart:io' show File;

import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_keys.dart';

final class FirebaseStoregeService {
  FirebaseStoregeService(String? path, this._name)
      : _fileRef = FirebaseStorage.instance.ref(path);

  final Reference _fileRef;
  final String? _name;

  void download({
    required void Function() onRunning,
    required void Function() onSuccess,
    required void Function() onError,
  }) async {
    final file = await File('${FirebaseCollections.localeAudiosPath}/$_name')
        .create(recursive: true);
    final downloadTask = _fileRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          onRunning();
        case TaskState.success:
          onSuccess();
        default:
          onError();
      }
    }).onError((_) => onError());
  }
}
