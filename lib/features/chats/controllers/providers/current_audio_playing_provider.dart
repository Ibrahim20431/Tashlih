import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

final currentAudioPlayingProvider = StateProvider<String?>((_) => null);
