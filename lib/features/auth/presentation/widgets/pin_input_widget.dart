import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

class PinInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const PinInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: TextStyles.largeBold,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(AppDimensions.radius18),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyWith(
      textStyle: TextStyles.largeBold.copyWith(color: primaryColor),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(AppDimensions.radius18),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.red, width: 1),
        borderRadius: BorderRadius.circular(AppDimensions.radius18),
      ),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: controller,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        errorPinTheme: errorPinTheme,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        showCursor: false,
        onTapOutside: (_) => context.unFocusScope(),
        validator: (code) {
          if (code == null || code.length < 4) {
            return 'يرجى إدخال الرمز كاملاً';
          }
          return null;
        },
        errorBuilder: (error, _) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                error!,
                style: TextStyles.smallBold.copyWith(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
