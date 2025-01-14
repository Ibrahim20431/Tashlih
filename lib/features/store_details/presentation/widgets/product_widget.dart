import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/card_with_image_widget.dart';
import '../../../product_details/data/models/product_model.dart';
import '../../data/models/store_model.dart';

class ProductWidget extends ConsumerWidget {
  const ProductWidget({
    super.key,
    required this.onTap,
    required this.store,
    required this.product,
    this.action = const SizedBox(),
  });

  final VoidCallback onTap;
  final StoreModel store;
  final ProductModel product;
  final Widget action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardWithImageWidget(
      image: product.image!,
      imageSize: 80,
      onTap: onTap,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: TextStyles.largeBold.copyWith(color: Colors.green),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            action,
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.car_rental_outlined,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              product.hasWarranty
                  ? 'نوع المنتج ${product.company.name}'
                  : product.warranty,
              style: TextStyles.mediumBold.copyWith(
                color: primaryColor,
              ),
            )
          ],
        )
      ],
    );
  }
}
