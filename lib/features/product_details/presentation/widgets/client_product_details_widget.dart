import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';
import 'product_details_widget.dart';
import 'product_info_widget.dart';

class ClientProductDetailsWidget extends StatelessWidget {
  const ClientProductDetailsWidget({
    super.key,
    required this.product,
    required this.price,
    this.store = const SizedBox.shrink(),
    required this.children,
    this.bottom = const SizedBox.shrink(),
  });

  final ProductModel product;
  final Widget price;
  final Widget store;
  final List<Widget> children;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return ProductDetailsWidget(
      product: product,
      store: store,
      trailing: price,
      bottom: bottom,
      children: [
        ProductInfoWidget(
          icon: Icons.car_crash_outlined,
          label: 'الحالة',
          value: product.conditionAr,
        ),
        const SizedBox(height: 16),
        // ProductInfoWidget(
        //   icon: Icons.local_police_outlined,
        //   label: 'الضمان',
        //   value: product.warranty,
        // ),
        ...children
      ],
    );
  }
}
