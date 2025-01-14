import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../../../../core/widgets/future_list_view.dart';
import '../../../../core/widgets/no_item_widget.dart';
import '../../../offers/models/order_offer_model.dart';
import '../../data/models/search_model.dart';
import 'order_offer_widget.dart';

class OffersFutureListView extends StatelessWidget {
  const OffersFutureListView({
    super.key,
    this.onRefresh,
    this.refreshProvider,
    required this.padding,
    required this.getItems,
    required this.offerBuilder,
  });

  final VoidCallback? onRefresh;
  final StateProvider<SearchModel>? refreshProvider;
  final EdgeInsets padding;
  final Future<List<OrderOfferModel>> Function() getItems;
  final OrderOfferWidget Function(OrderOfferModel) offerBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureListView(
      onRefresh: onRefresh,
      padding: padding,
      refreshProvider: refreshProvider,
      getItems: getItems,
      itemBuilder: (offer, _) => offerBuilder(offer),
      noItemWidget: const NoItemWidget(
        icon: Icons.menu,
        title: 'لا توجد عروض',
      ),
    );
  }
}
