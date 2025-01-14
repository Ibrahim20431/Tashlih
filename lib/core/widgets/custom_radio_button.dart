import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/text_styles.dart';

class CustomRadioButton<T> extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onTap,
    required this.label,
  });

  final T value;
  final T groupValue;
  final void Function() onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color cardColor;
    final Color textColor;
    if(value == groupValue) {
      cardColor = primaryColor;
      textColor = Colors.white;
    } else {
      textColor = primaryColor;
      cardColor = Colors.white;
    }
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius10),
        side: const BorderSide(color: primaryColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(value: value, groupValue: groupValue, onChanged: null),
              const SizedBox(width: 12),
              Text(label, style: TextStyles.mediumBold.copyWith(
                color: textColor,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
