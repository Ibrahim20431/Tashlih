import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../controllers/notifiers/auth_notifier.dart';
import '../widgets/auth_scaffold_widget.dart';
import '../widgets/mobile_text_field.dart';

class ForgetPasswordView extends ConsumerStatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  ConsumerState<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends ConsumerState<ForgetPasswordView>
    with ValidationMixin {
  final formKey = GlobalKey<FormState>();

  final mobile = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mobile.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'نسيت كلمة المرور',
      subtitle: 'ادخل رقم جوالك\nسيتم إرسال رمز التحقق إلى رقم هاتفك',
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        children: [
          const SizedBox(height: 40),
          Form(
            key: formKey,
            child: MobileTextField(
              controller: mobile,
              validator: phoneValidation,
            ),
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref
                    .read(authNotifierProvider.notifier)
                    .checkUserMobile(mobile.text);
              }
            },
            child: const Text('إرسال'),
          )
        ],
      ),
    );
  }
}
