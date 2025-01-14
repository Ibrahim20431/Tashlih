import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../providers/order_offers_provider.dart';
import '../widgets/offers_future_list_view.dart';
import '../widgets/order_offer_widget.dart';
import 'client_offer_details_view.dart';

class OrderOffersView extends ConsumerWidget {
  const OrderOffersView(this.id, this.name, {super.key});

  final int id;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AppScaffold(
        title: 'قائمة العروض',
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Text(
                name,
                style: TextStyles.largeBold.copyWith(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: OffersFutureListView(
                onRefresh: () => ref.invalidate(orderOffersProvider(id)),
                padding: const EdgeInsets.only(
                  bottom: AppDimensions.screenPadding,
                  right: AppDimensions.screenPadding,
                  left: AppDimensions.screenPadding,
                ),
                getItems: () {
                  return ref.read(orderOffersProvider(id).future);
                },
                offerBuilder: (offer) {
                  final store = offer.store;
                  return OrderOfferWidget(
                    title: 'عرض ${store.name}',
                    offer: offer,
                    onTap: () =>
                        context.push(ClientOfferDetailsView(offer, store)),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
