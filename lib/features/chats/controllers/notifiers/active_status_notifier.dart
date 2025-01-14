import 'dart:async' show StreamSubscription;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_enums.dart';
import '../../../../core/firebase/firebase_database_service.dart';

final class ActiveStatusNotifier extends StateNotifier<UserPresence> {
  ActiveStatusNotifier(Ref ref, this._userId) : super(UserPresence.offline) {
    _getUserStatus();
  }

  final int _userId;

  final FirebaseDatabaseService _database = const FirebaseDatabaseService();

  late final StreamSubscription<DatabaseEvent> _activeStatusStream;

  void _getUserStatus() {
    _activeStatusStream = _database.activeStatusStream(_userId).listen((event) {
      final value = event.snapshot.value as String?;
      if (value != null) state = UserPresence.values.byName(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _activeStatusStream.cancel();
  }
}

final activeStatusNotifierProvider =
    StateNotifierProvider.family<ActiveStatusNotifier, UserPresence, int>(
        ActiveStatusNotifier.new);
