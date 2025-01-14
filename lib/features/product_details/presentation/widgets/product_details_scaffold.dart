import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/utils/helpers/lunch_dial_tel.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../store_details/data/models/store_model.dart';
import '../../data/models/product_model.dart';
import 'Product_price_widget.dart';
import 'product_info_widget.dart';
import 'client_product_details_widget.dart';
import 'store_tile.dart';

class ProductDetailsScaffold extends ConsumerWidget {
  const ProductDetailsScaffold({
    super.key,
    this.onStoreTap,
    required this.store,
    required this.chop,
    this.actionButton = const SizedBox(),
  });

  final VoidCallback? onStoreTap;
  final StoreModel store;
  final ProductModel chop;
  final Widget actionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AppScaffold(
        title: 'التفاصيل',
        body: ClientProductDetailsWidget(
          product: chop,
          price: chop.hasPrice
              ? ProductPriceWidget(chop.price!)
              : const SizedBox.shrink(),
          store: StoreTile(store, onTap: onStoreTap),
          children: [
            const CustomDivider(),
            ProductInfoWidget(
              icon: Icons.call_outlined,
              label: 'اتصال',
              value: store.mobile,
              valueStyle: TextStyles.mediumBold.copyWith(color: primaryColor),
              valueCardColor: primaryColor[300]!.withOpacity(.08),
              onTap: () => lunchDialTel(store.mobile),
            ),
            actionButton,
            const SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}
