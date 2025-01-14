import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/card_with_image_widget.dart';
import '../../../../core/widgets/price_format_text.dart';
import '../../../my_orders/presentation/widgets/order_status_widget.dart';
import '../../../offers/models/order_offer_model.dart';

class OrderOfferWidget extends StatelessWidget {
  const OrderOfferWidget({
    super.key,
    required this.title,
    required this.offer,
    required this.onTap,
  });

  final String title;
  final OrderOfferModel offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final product = offer.product;
    return CardWithImageWidget(
      image: product.image!,
      onTap: onTap,
      imageSize: 110,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyles.smallBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(offer.date, style: TextStyles.smallMedium),
          ],
        ),
        _InfoRow(
          label: 'حالة القطعة',
          value: Text(product.conditionAr, style: TextStyles.smallBold),
        ),
        _InfoRow(
          label: 'السعر',
          value: Consumer(
            builder: (_, WidgetRef ref, __) {
              final offerState = ref.watch(offer.offerNotifierProvider);
              return PriceFormatText(
                offerState.priceWithVat,
                style: TextStyles.smallBold.copyWith(color: primaryColor),
              );
            },
          ),
        ),
        _InfoRow(
          label: 'الحالة',
          value: Consumer(
            builder: (_, WidgetRef ref, __) {
              final offerState = ref.watch(offer.offerNotifierProvider);
              return OrderStatusWidget(offerState.status);
            },
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.smallMedium,
          ),
        ),
        const SizedBox(width: 8),
        value,
      ],
    );
  }
}
