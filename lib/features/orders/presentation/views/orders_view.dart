import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../home/presentation/widgets/search_with_filters_widget.dart';
import '../../../home/providers/city_filters_provider.dart';
import '../../../my_orders/data/models/order_model.dart';
import '../../../my_orders/presentation/widgets/icon_text_widget.dart';
import '../../../my_orders/presentation/widgets/order_widget.dart';
import '../../../my_orders/presentation/widgets/orders_pagination_widget.dart';
import '../../providers/orders_provider.dart';
import 'order_details_view.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({super.key});

  @override
  ConsumerState<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  final controller = PagingController<int, OrderModel>(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    _listenFilterState();
    return AppScaffold(
      title: 'طلبات التشليح',
      body: Padding(
        padding: const EdgeInsets.only(
          left: AppDimensions.screenPadding,
          top: AppDimensions.screenPadding,
          right: AppDimensions.screenPadding,
        ),
        child: Column(
          children: [
            SearchWithFiltersWidget(cityFiltersProvider),
            Expanded(
              child: OrdersPaginationWidget(
                controller: controller,
                padding: const EdgeInsets.only(
                  top: AppDimensions.screenPadding,
                  bottom: AppDimensions.bottomBarWithFABPadding,
                ),
                ordersProvider: ordersProvider,
                itemBuilder: (order) => OrderWidget(
                  order,
                  info: IconTextWidget(
                    Icons.local_shipping_outlined,
                    order.city,
                  ),
                  onTap: () => context.push(OrderDetailsView(order)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listenFilterState() {
    ref.listen(cityFiltersProvider, (previous, next) {
      ref.invalidate(ordersProvider);
      controller.refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
