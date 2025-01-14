import 'dart:ui' show AppLifecycleState;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLifeCycleProvider = StateProvider((_) => AppLifecycleState.resumed);
