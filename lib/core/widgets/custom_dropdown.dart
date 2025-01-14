import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    this.hintText = '',
    this.icon,
    this.value,
    this.items,
    this.onChanged,
    this.borderRadius = AppDimensions.widgetRadius,
    this.borderColor = Colors.grey,
    this.height,
    this.style,
    this.hintStyle,
    this.onTap,
    Widget? suffixIcon,
  }) : suffixIcon = suffixIcon ??
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: primaryColor,
            );

  final String hintText;
  final IconData? icon;
  final Widget suffixIcon;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final double borderRadius;
  final Color borderColor;
  final double? height;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              const SizedBox(width: 12),
              if (icon != null) Icon(icon, color: primaryColor),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    items: items,
                    isExpanded: true,
                    style: style,
                    dropdownColor: context.theme.scaffoldBackgroundColor,
                    hint: AutoSizeText(hintText, style: hintStyle, maxLines: 1),
                    icon: suffixIcon,
                    padding: const EdgeInsets.only(
                      top: 1,
                      bottom: 3,
                      right: 12,
                      left: 14,
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
