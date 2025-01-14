import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/search_params_model.dart';
import '../../../../core/widgets/future_cities_dropdown.dart';
import '../../../../core/widgets/search_text_field.dart';

class SearchWithFiltersWidget extends ConsumerWidget {
  const SearchWithFiltersWidget(this.filtersProvider, {super.key});

  final StateProvider<SearchParamsModel> filtersProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: FutureCitiesDropdown(filtersProvider: filtersProvider),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: SearchTextField(
            onChangesEnd: (search) {
              ref.read(filtersProvider.notifier).update(
                    (filter) => filter.copyWith(newSearch: search),
                  );
            },
          ),
        ),
      ],
    );
  }
}
