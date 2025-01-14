import 'package:flutter/widgets.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/price_format_text.dart';

class ProductPriceWidget extends StatelessWidget {
  const ProductPriceWidget(
    this.price, {
    super.key,
    this.updatePrice = const SizedBox.shrink(),
  });

  final num price;
  final Widget updatePrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(PngIcons.pay, width: 20),
        const SizedBox(width: 8),
        PriceFormatText(
          price,
          style: TextStyles.largeBold.copyWith(
            color: primaryColor,
          ),
        ),
        updatePrice,
      ],
    );
  }
}
