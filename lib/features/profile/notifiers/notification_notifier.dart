import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/state_request_mixin.dart';
import '../../../core/constants/key_classes.dart';
import '../../../core/providers/shared_prefs_provider.dart';
import '../../../core/utils/helpers/exception_handler.dart';
import '../../auth/controllers/providers/user_provider.dart';
import '../data/repositories/profile_repository.dart';

final class NotificationNotifier extends StateNotifier<void>
    with StateRequestMixin {
  NotificationNotifier(this._ref)
      : _repo = _ref.read(profileRepoProvider),
        super(null) {
    super.initializeRef(_ref);
  }

  final Ref _ref;
  final ProfileRepository _repo;

  void change() async {
    try {
      super.loading();

      final user = _ref.read(userProvider)!;

      final status = await _repo.changeNotificationStatus(
        !user.notificationStatus,
      );

      final newUser = user.copyWith(notificationStatus: status);
      _ref
          .read(sharedPrefsProvider)
          .setString(StorageKeys.user, newUser.toJson());
      _ref.read(userProvider.notifier).state = newUser;

      if (status) {
        super.success('تم تفعيل الإشعارات');
      } else {
        super.success('تم إيقاف الإشعارات');
      }
    } catch (e) {
      super.error(e, exceptionHandler(e));
    }
  }
}

final notificationNotifierProvider =
    StateNotifierProvider.autoDispose<NotificationNotifier, void>(
        NotificationNotifier.new);
