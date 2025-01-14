import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../../profile/data/repositories/profile_repository.dart';

final myStoreDetailsProvider = FutureProvider.autoDispose((ref) {
  final repo = ref.read(profileRepoProvider);
  return repo.getMyStoreDetails();
});
