import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_texts.dart';
import '../widgets/auth_scaffold_widget.dart';
import '../widgets/pin_input_widget.dart';

class PinCodeView extends StatefulWidget {
  const PinCodeView({super.key, required this.onValidated});

  final void Function(String) onValidated;

  @override
  State<PinCodeView> createState() => _PinCodeViewState();
}

class _PinCodeViewState extends State<PinCodeView> {
  final formKey = GlobalKey<FormState>();

  final code = TextEditingController();

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'رمز الكود',
      subtitle: 'ادخل رمز الكود\nتم إرسال رمز التفعيل إلى رقم جوالك',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Form(
              key: formKey,
              child: PinInputWidget(controller: code),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  widget.onValidated(code.text);
                }
              },
              child: const Text(AppTexts.activate),
            ),
          ],
        ),
      ),
    );
  }
}
