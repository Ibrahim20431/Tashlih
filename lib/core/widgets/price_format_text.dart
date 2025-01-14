import 'package:flutter/widgets.dart';

import '../constants/globals.dart';

class PriceFormatText extends StatelessWidget {
  const PriceFormatText(this.price, {super.key, this.style});

  final num price;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${priceFormat.format(price)} ر.س',
      style: style,
    );
  }
}
