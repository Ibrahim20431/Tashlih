import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/widgets/no_item_widget.dart';
import '../../../../core/widgets/pagination_grid_view.dart';
import '../../../store_details/data/models/store_model.dart';
import 'store_card_widget.dart';

class StoresGridView extends ConsumerWidget {
  const StoresGridView({
    super.key,
    required this.controller,
    required this.getList,
    required this.onRefresh,
  });

  final PagingController<int, StoreModel> controller;
  final Future<PaginationModel<StoreModel>> Function(int) getList;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationGridView(
      padding: const EdgeInsets.only(
        top: AppDimensions.screenPadding,
        bottom: AppDimensions.bottomBarWithFABPadding,
      ),
      controller: controller,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1 / 1.2,
      ),
      getList: getList,
      itemBuilder: (store, _) => StoreCardWidget(store),
      onRefresh: onRefresh,
      noItemWidget: const NoItemWidget(
        icon: Icons.search_off_rounded,
        title: 'لا توجد نتيجة',
      ),
    );
  }
}
