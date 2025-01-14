import 'package:flutter/widgets.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

class StoreContactWidget extends StatelessWidget {
  const StoreContactWidget({
    super.key,
    required this.icon,
    required this.label,
    this.style = TextStyles.largeMedium,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final TextStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: onTap,
              child: Text(label, style: style),
            ),
          ),
        )
      ],
    );
  }
}
