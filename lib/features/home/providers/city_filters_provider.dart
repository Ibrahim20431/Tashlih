import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../../../core/models/search_params_model.dart';

final cityFiltersProvider = StateProvider(
  (_) => const SearchParamsModel(),
);
