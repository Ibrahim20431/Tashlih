import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Consumer, WidgetRef;

import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/card_with_image_widget.dart';
import '../../data/models/order_model.dart';
import 'icon_text_widget.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget(
    this.order, {
    super.key,
    required this.onTap,
    required this.info,
    this.action = const SizedBox(),
  });

  final VoidCallback onTap;
  final OrderModel order;
  final Widget info;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return CardWithImageWidget(
      image: order.image!,
      onTap: onTap,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                order.name,
                style: TextStyles.mediumBold.copyWith(color: Colors.green),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            action,
          ],
        ),
        Text(order.part.name, style: TextStyles.smallMedium),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Consumer(
                builder: (_, WidgetRef ref, __) {
                  final count = ref.watch(order.offersCountProvider);
                  return IconTextWidget(
                    Icons.receipt_outlined,
                    '$count عروض',
                  );
                },
              ),
            ),
            Expanded(flex: 3, child: info),
          ],
        ),
      ],
    );
  }
}
