import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter/widgets.dart';

import '../utils/validation_mixin.dart';
import 'custom_text_field.dart';

class PriceTextField extends StatelessWidget with ValidationMixin {
  const PriceTextField({
    super.key,
    required this.controller,
    this.isRequired = true,
  });

  final TextEditingController controller;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'السعر',
      prefixIcon: Icons.payments_outlined,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      suffixIcon: const Text('ر.س'),
      validator: (val) {
        if (isRequired) return requiredValidation(val, 'السعر');
        return null;
      },
    );
  }
}
