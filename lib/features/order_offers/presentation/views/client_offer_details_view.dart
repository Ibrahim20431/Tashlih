import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../chats/data/models/chat_model.dart';
import '../../../product_details/presentation/widgets/product_price_widget.dart';
import '../../../product_details/presentation/widgets/store_tile.dart';
import '../../../store_details/data/models/store_model.dart';
import '../../../store_details/presentation/views/store_details_view.dart';
import '../../../offers/models/order_offer_model.dart';
import '../widgets/offer_completed_status_widget.dart';
import '../widgets/offer_status_button.dart';
import 'order_offer_view.dart';

class ClientOfferDetailsView extends StatelessWidget {
  const ClientOfferDetailsView(this.offer, this.store, {super.key});

  final OrderOfferModel offer;
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return OrderOfferView(
      offer: offer,
      chat: ChatModel(
        doc: offer.chatDoc,
        id: store.userId,
        name: store.name,
        image: store.image,
      ),
      price: ProductPriceWidget(offer.product.price!),
      store: StoreTile(
        store,
        onTap: () => context.push(StoreDetailsView(store)),
      ),
      button: Consumer(
        builder: (_, WidgetRef ref, __) {
          final offerState = ref.watch(offer.offerNotifierProvider);
          return switch (offerState.status) {
            OrderOfferStatus.waiting => OfferStatusButton(
                color: Colors.green,
                label: 'قبول',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  ref.read(offer.offerNotifierProvider.notifier).accept();
                },
              ),
            OrderOfferStatus.paymentWaiting => OfferStatusButton(
                color: Colors.green,
                label: 'تأكيد تحويل المبلغ',
                icon: Icons.receipt_long_outlined,
                onPressed: () {
                  ref.read(offer.offerNotifierProvider.notifier).paymentSent();
                },
              ),
            OrderOfferStatus.paymentVerifying => const OfferStatusButton(
                color: Colors.orange,
                label: 'جار التحقق من الدفع',
                icon: Icons.access_time,
              ),
            OrderOfferStatus.payed => const OfferStatusButton(
                color: Colors.orange,
                label: 'معالجة الطلب',
                icon: Icons.work_history_outlined,
              ),
            OrderOfferStatus.shipping => OfferStatusButton(
                color: Colors.green,
                label: 'تأكيد استلام الطلب',
                icon: Icons.local_shipping_outlined,
                onPressed: () {
                  ref.read(offer.offerNotifierProvider.notifier).completed();
                },
              ),
            OrderOfferStatus.completed => OfferCompletedStatusWidget(
                offer.id,
                offer.product.name,
              ),
            OrderOfferStatus.rejected => const OfferStatusButton(
                color: AppColors.red,
                label: 'مرفوض',
                icon: Icons.clear_rounded,
              ),
          };
        },
      ),
    );
  }
}
