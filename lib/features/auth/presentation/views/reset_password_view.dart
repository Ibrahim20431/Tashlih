import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../controllers/notifiers/auth_notifier.dart';
import '../widgets/auth_scaffold_widget.dart';
import '../widgets/password_text_field.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView>
    with ValidationMixin {
  final password = TextEditingController();
  final passwordConf = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    password.dispose();
    passwordConf.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'نسيت كلمة المرور',
      subtitle: 'كلمة المرور الجديدة\nإعادة ضبط كلمة المرور',
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        children: [
          const SizedBox(height: 40),
          PasswordTextField(
            controller: password,
            validator: passwordValidation,
            labelText: 'كلمة المرور',
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: passwordConf,
            validator: (val) => passwordConfValidation(val, password.text),
            labelText: 'تأكيد كلمة المرور',
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).resetPassword(
                    password.text,
                    passwordConf.text,
                  );
            },
            child: const Text('إعادة ضبط'),
          )
        ],
      ),
    );
  }
}
