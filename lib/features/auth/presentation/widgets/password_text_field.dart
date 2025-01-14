import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
  });

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      obscureText: obscureText,
      prefixIcon: Icons.lock,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        icon: Icon(
          obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
        ),
      ),
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      preventToolbarOptions: const [
        ContextMenuButtonType.copy,
        ContextMenuButtonType.cut,
        ContextMenuButtonType.searchWeb,
        ContextMenuButtonType.share,
        ContextMenuButtonType.lookUp,
      ],
    );
  }
}
