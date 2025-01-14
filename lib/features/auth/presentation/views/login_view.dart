import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_classes.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../main_layout/presentation/layouts/main_layout.dart';
import '../../controllers/notifiers/auth_notifier.dart';
import '../widgets/password_text_field.dart';
import '../widgets/mobile_text_field.dart';
import 'forget_password_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  static const String routeName = '/login';

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  final mobile = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    mobile.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding, vertical: 26),
        children: [
          MobileTextField(
            controller: mobile,
            validator: phoneValidation,
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: password,
            labelText: AppTexts.password,
            validator: (val) => requiredValidation(val, AppTexts.password),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => context.push(const ForgetPasswordView()),
              child: const Text(AppTexts.forgetPassword),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref.read(authNotifierProvider.notifier).login(
                      mobile.text,
                      password.text,
                    );
              }
            },
            child: const Text(AppTexts.login),
          ),
          const SizedBox(height: 30),
          OutlinedButton(
            onPressed: () {
              context.pushReplacement(const MainLayout());
              final prefs = ref.read(sharedPrefsProvider);
              prefs.setBool(StorageKeys.goToHome, true);
            },
            child: const Text('الدخول كزائر'),
          )
        ],
      ),
    );
  }
}
