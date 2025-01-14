import 'package:flutter/widgets.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/info_card.dart';

class ProductInfoWidget extends StatelessWidget {
  const ProductInfoWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueCardColor = AppColors.lightGrey,
    this.valueStyle = TextStyles.mediumRegular,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextStyle valueStyle;
  final Color valueCardColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 16),
        Expanded(child: Text(label)),
        GestureDetector(
          onTap: onTap,
          child: InfoCard(
            color: valueCardColor,
            info: value,
            style: valueStyle,
          ),
        )
      ],
    );
  }
}
