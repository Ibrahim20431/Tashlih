import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/request_state.dart';

final requestProvider = StateProvider<RequestState>((_) => const InitState());