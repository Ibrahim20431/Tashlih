import 'package:flutter/widgets.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/text_styles.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    this.color = AppColors.lightGrey,
    required this.info,
    this.style = TextStyles.mediumRegular,
  });

  final Color color;
  final String info;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimensions.radius5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text(info, style: style),
      ),
    );
  }
}
