import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../../../core/models/search_params_model.dart';

final specializedCentersFiltersProvider = StateProvider(
      (_) => const SearchParamsModel(),
);
