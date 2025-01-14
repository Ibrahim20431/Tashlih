import 'dart:io' show File;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_enums.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../../core/firebase/firebase_storege_service.dart';

final class AudioStateNotifier extends StateNotifier<AudioPlayerState> {
  AudioStateNotifier(super.state, String? path, String? name)
      : _storege = FirebaseStoregeService(path, name);

  final FirebaseStoregeService _storege;

  void download() {
    _storege.download(
      onRunning: () => state = AudioPlayerState.loading,
      onSuccess: () => state = AudioPlayerState.paused,
      onError: () => state = AudioPlayerState.notExist,
    );
  }

  void isPlaying(bool isPlaying) {
    state = isPlaying ? AudioPlayerState.playing : AudioPlayerState.paused;
  }
}

final audioStateNotifierProvider =
    StateNotifierProvider.family<AudioStateNotifier, AudioPlayerState, String?>(
        (_, path) {
  final AudioPlayerState state;
  final name = path?.split('/').last;
  if (path != null) {
    final localPath = '${FirebaseCollections.localeAudiosPath}/$name';
    if (File(localPath).existsSync()) {
      state = AudioPlayerState.paused;
    } else {
      state = AudioPlayerState.notExist;
    }
  } else {
    state = AudioPlayerState.paused;
  }
  return AudioStateNotifier(state, path, name);
});
