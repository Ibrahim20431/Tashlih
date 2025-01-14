import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

class IconTextWidget extends StatelessWidget {
  const IconTextWidget(
    this.icon,
    this.text, {
    super.key,
    this.iconColor = primaryColor,
  });

  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 4),
        Text(text, style: TextStyles.smallMedium),
      ],
    );
  }
}
