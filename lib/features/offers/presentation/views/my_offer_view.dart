import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/alert_dialog_header.dart';
import '../../../../core/widgets/price_text_field.dart';
import '../../../chats/data/models/chat_model.dart';
import '../../../order_offers/presentation/widgets/offer_completed_status_widget.dart';
import '../../../order_offers/presentation/widgets/offer_status_button.dart';
import '../../../product_details/presentation/widgets/product_price_widget.dart';
import '../../models/order_offer_model.dart';
import '../../../order_offers/presentation/views/order_offer_view.dart';

class MyOfferView extends StatelessWidget {
  const MyOfferView(this.offer, {super.key});

  final OrderOfferModel offer;

  @override
  Widget build(BuildContext context) {
    final user = offer.orderUser;
    return OrderOfferView(
      offer: offer,
      chat: ChatModel(
        doc: offer.chatDoc,
        id: user.id,
        name: user.name,
        image: user.image,
      ),
      price: Consumer(
        builder: (_, WidgetRef ref, __) {
          final offerState = ref.watch(offer.offerNotifierProvider);
          return ProductPriceWidget(
            offerState.priceWithVat,
            updatePrice: offerState.status == OrderOfferStatus.waiting
                ? TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      final formKey = GlobalKey<FormState>();
                      final controller = TextEditingController(
                        text: '${offerState.priceBeforeVat}',
                      );
                      context.showCustomDialog(
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AlertDialogHeader(
                              icon: Icons.price_change_rounded,
                              color: primaryColor,
                              title: 'تعديل سعر العرض',
                            ),
                            const SizedBox(height: 16),
                            Form(
                              key: formKey,
                              child: PriceTextField(controller: controller),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.pop();
                                  ref
                                      .read(
                                          offer.offerNotifierProvider.notifier)
                                      .updatePrice(controller.text);
                                }
                              },
                              child: const Text('تعديل'),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: context.pop,
                              child: const Text('رجوع'),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('تعديل'),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
      button: Consumer(
        builder: (_, WidgetRef ref, __) {
          final offerState = ref.watch(offer.offerNotifierProvider);
          return switch (offerState.status) {
            OrderOfferStatus.waiting => const OfferStatusButton(
                color: Colors.orange,
                label: 'بانتظار الموافقة',
                icon: Icons.access_time,
              ),
            OrderOfferStatus.paymentWaiting => const OfferStatusButton(
                color: Colors.green,
                label: 'مقبول بانتظار الدفع',
                icon: Icons.check_circle_outline,
              ),
            OrderOfferStatus.paymentVerifying => OfferStatusButton(
                color: Colors.green,
                label: 'تأكيد استلام المبلغ',
                icon: Icons.receipt_long_rounded,
                onPressed: () {
                  ref
                      .read(offer.offerNotifierProvider.notifier)
                      .paymentVerified();
                },
              ),
            OrderOfferStatus.payed => OfferStatusButton(
                color: Colors.green,
                label: 'شحن الطلب',
                icon: Icons.local_shipping_outlined,
                onPressed: () {
                  ref.read(offer.offerNotifierProvider.notifier).shipping();
                },
              ),
            OrderOfferStatus.shipping => const OfferStatusButton(
                color: Colors.orange,
                label: 'جار الشحن',
                icon: Icons.local_shipping_outlined,
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
