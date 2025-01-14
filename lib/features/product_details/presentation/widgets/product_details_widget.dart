import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/globals.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/network_image_widget.dart';
import '../../../manage_product/data/models/base_product_model.dart';
import 'product_info_widget.dart';

class ProductDetailsWidget extends StatelessWidget {
  const ProductDetailsWidget({
    super.key,
    required this.product,
    this.store = const SizedBox.shrink(),
    this.trailing = const SizedBox.shrink(),
    required this.children,
    this.bottom = const SizedBox.shrink(),
  });

  final BaseProductModel product;
  final Widget store;
  final Widget trailing;
  final List<Widget> children;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        AspectRatio(
          aspectRatio: productImageAspectRatio,
          child: NetworkImageWidget(
            product.image!,
            borderRadius: const BorderRadius.all(Radius.zero),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(product.name, style: TextStyles.largeBold),
                  ),
                  const SizedBox(width: 8),
                  trailing
                ],
              ),
              if (product.hasNote) ...[
                const SizedBox(height: 8),
                Text(product.note!),
              ],
              store,
              const SizedBox(height: 24),
              ProductInfoWidget(
                icon: Icons.factory_outlined,
                label: 'الماركة',
                value: product.company.name,
              ),
              const SizedBox(height: 16),
              ProductInfoWidget(
                icon: Icons.car_rental_outlined,
                label: 'النوع',
                value: product.brand.name,
              ),
              const SizedBox(height: 16),
              ProductInfoWidget(
                icon: Icons.date_range_rounded,
                label: 'الموديل',
                value: product.model,
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
        bottom,
        const SizedBox(height: 30),
      ],
    );
  }
}
