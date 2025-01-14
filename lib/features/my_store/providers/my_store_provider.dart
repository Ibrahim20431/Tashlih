import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../../store_details/data/models/store_model.dart';

final myStoreProvider = FutureProvider.autoDispose<StoreModel>((ref) {
  final repo = ref.read(profileRepoProvider);
  return repo.getMyStore();
});
