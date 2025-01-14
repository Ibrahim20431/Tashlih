import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../more/data/repositories/more_repository.dart';
import '../data/models/more_page_model.dart';

final morePagesProvider = FutureProvider<List<MorePageModel>>((ref) {
  final repo = ref.read(moreRepoProvider);
  return repo.getPages();
});
