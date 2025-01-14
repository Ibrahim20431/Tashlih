import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../data/repositories/auth_repository.dart';

final carBrandsProvider = FutureProvider((ref) {
  final repo = ref.read(authRepoProvider);
  return repo.getCarBrands();
});
