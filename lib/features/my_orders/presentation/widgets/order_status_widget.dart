import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/key_enums.dart';
import 'icon_text_widget.dart';

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget(this.status, {super.key});

  final OrderOfferStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      OrderOfferStatus.waiting => const IconTextWidget(
          Icons.event_available,
          'متاح',
        ),
      OrderOfferStatus.paymentWaiting => const IconTextWidget(
          Icons.receipt_long_rounded,
          'انتظار الدفع',
          iconColor: Colors.orange,
        ),
      OrderOfferStatus.paymentVerifying => const IconTextWidget(
          Icons.pending_actions_rounded,
          'التحقق من الدفع',
          iconColor: Colors.orange,
        ),
      OrderOfferStatus.payed => const IconTextWidget(
          Icons.fact_check_outlined,
          'تم التحقق',
          iconColor: Colors.green,
        ),
      OrderOfferStatus.shipping => const IconTextWidget(
          Icons.local_shipping_outlined,
          'جار الشحن',
          iconColor: Colors.orange,
        ),
      OrderOfferStatus.completed => const IconTextWidget(
          Icons.handshake_outlined,
          'مكتمل',
          iconColor: Colors.green,
        ),
      OrderOfferStatus.rejected => const IconTextWidget(
          Icons.cancel_outlined,
          'ملغي',
          iconColor: AppColors.red,
        ),
    };
  }
}
