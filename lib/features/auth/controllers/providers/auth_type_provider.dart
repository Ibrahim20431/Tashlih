import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../../../../core/constants/key_enums.dart';

final authTypeProvider = StateProvider.autoDispose((_) => AuthType.login);
