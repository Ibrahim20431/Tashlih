import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;

import '../../../../core/constants/app_texts.dart';
import '../../../../core/widgets/custom_text_field.dart';

class MobileTextField extends StatelessWidget {
  const MobileTextField({
    super.key,
    required this.controller,
    this.validator,
    this.readOnly = false,
    this.fillColor = Colors.white,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      prefixIcon: Icons.phone_android_rounded,
      labelText: AppTexts.phoneNumber,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 10,
      validator: validator,
      readOnly: readOnly,
      fillColor: fillColor,
    );
  }
}
