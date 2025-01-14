import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_enums.dart';

final userTypeProvider = StateProvider.autoDispose((_) => UserType.client);
