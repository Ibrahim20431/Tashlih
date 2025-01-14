import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_field.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
    required this.validator,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'البريد الإلكتروني',
      prefixIcon: Icons.email_rounded,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
    );
  }
}
