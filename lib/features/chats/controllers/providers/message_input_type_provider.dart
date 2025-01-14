import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../../../../core/constants/key_enums.dart' show MessageType;

final messageInputTypeProvider =
    StateProvider.autoDispose((_) => MessageType.text);
