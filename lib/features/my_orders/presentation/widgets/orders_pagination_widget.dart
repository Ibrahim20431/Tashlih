import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/models/pagination_model.dart';
import '../../../../core/widgets/no_item_widget.dart';
import '../../../../core/widgets/pagination_list_view.dart';
import '../../data/models/order_model.dart';

class OrdersPaginationWidget extends ConsumerWidget {
  const OrdersPaginationWidget({
    super.key,
    this.controller,
    required this.ordersProvider,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(0),
  });

  final PagingController<int, OrderModel>? controller;
  final FutureProviderFamily<PaginationModel<OrderModel>, int> ordersProvider;
  final Widget Function(OrderModel) itemBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView(
      controller: controller,
      padding: padding,
      getList: (page) {
        return ref.read(ordersProvider(page).future);
      },
      itemBuilder: (order, _) => itemBuilder(order),
      noItemWidget: const NoItemWidget(
        icon: Icons.no_backpack_outlined,
        title: 'لا توجد طلبات',
      ),
      onRefresh: () => ref.invalidate(ordersProvider),
    );
  }
}
