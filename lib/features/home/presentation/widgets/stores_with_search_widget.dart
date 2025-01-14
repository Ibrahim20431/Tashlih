import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/core.dart';
import '../../../../core/models/search_params_model.dart';
import '../../../store_details/data/models/store_model.dart';
import 'search_with_filters_widget.dart';
import 'stores_grid_view.dart';

class StoresWithSearchWidget extends ConsumerStatefulWidget {
  const StoresWithSearchWidget({
    super.key,
    required this.storesProvider,
    required this.storesFiltersProvider,
  });

  final FutureProviderFamily<PaginationModel<StoreModel>, int> storesProvider;
  final StateProvider<SearchParamsModel> storesFiltersProvider;

  @override
  ConsumerState<StoresWithSearchWidget> createState() =>
      _StoresWithSearchState();
}

class _StoresWithSearchState extends ConsumerState<StoresWithSearchWidget> {
  final PagingController<int, StoreModel> pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  Widget build(BuildContext context) {
    _listenFilterState();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: Column(
        children: [
          SearchWithFiltersWidget(widget.storesFiltersProvider),
          Expanded(
            child: StoresGridView(
              controller: pagingController,
              getList: (page) {
                return ref.read(widget.storesProvider(page).future);
              },
              onRefresh: () => ref.invalidate(widget.storesProvider),
            ),
          )
        ],
      ),
    );
  }

  void _listenFilterState() {
    ref.listen(widget.storesFiltersProvider, (previous, next) {
      ref.invalidate(widget.storesProvider);
      pagingController.refresh();
    });
  }
}
