import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../add_order/controllers/notifiers/add_order_notifier.dart';
import '../../../order_offers/presentation/views/order_offers_view.dart';
import '../../../order_offers/providers/order_offers_provider.dart';
import '../../data/models/order_model.dart';
import '../../providers/client_orders_provider.dart';
import '../widgets/order_status_widget.dart';
import '../widgets/order_widget.dart';
import '../widgets/orders_pagination_widget.dart';

class MyOrdersView extends ConsumerStatefulWidget {
  const MyOrdersView({super.key});

  @override
  ConsumerState<MyOrdersView> createState() => _ClientOrdersViewState();
}

class _ClientOrdersViewState extends ConsumerState<MyOrdersView> {
  final controller = PagingController<int, OrderModel>(firstPageKey: 1);

  @override
  Widget build(BuildContext context) {
    _listenOrderState();
    return Scaffold(
      body: AppScaffold(
        title: 'طلباتي',
        body: OrdersPaginationWidget(
          controller: controller,
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          ordersProvider: clientOrdersProvider,
          itemBuilder: (order) => OrderWidget(
            order,
            action: GestureDetector(
              onTap: () {
                context.showAlertDialog(
                  icon: Icons.delete_forever,
                  color: AppColors.red,
                  title: 'حذف ${order.name}',
                  subtitle: 'سيتم حذف الطلب ولن يكون متاحاً، هل أنت متأكد؟',
                  confirmLabel: 'حذف',
                  onConfirmPressed: (context) {
                    context.pop();
                    ref
                        .read(orderNotifierProvider.notifier)
                        .deleteOrder(order.id!);
                  },
                  cancelLabel: 'الغاء',
                );
              },
              child: const Icon(
                Icons.delete_rounded,
                size: 20,
                color: AppColors.red,
              ),
            ),
            info: Consumer(
              builder: (_, WidgetRef ref, __) {
                final status = ref.watch(order.statusProvider);
                return OrderStatusWidget(status);
              },
            ),
            onTap: () {
              ref.invalidate(orderOffersProvider);
              context.push(OrderOffersView(order.id!, order.name));
            },
          ),
        ),
      ),
    );
  }

  void _listenOrderState() {
    ref.listen(orderNotifierProvider, (_, state) {
      if (state.hasData) {
        ref.invalidate(clientOrdersProvider);
        controller.refresh();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
