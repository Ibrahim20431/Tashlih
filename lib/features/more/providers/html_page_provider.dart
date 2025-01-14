import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../more/data/repositories/more_repository.dart';

final htmlPageProvider = FutureProvider.family<String, String>((ref, route) async {
  final repo = ref.read(moreRepoProvider);
  final page = await repo.getPage(route);
  return page.html;
});
