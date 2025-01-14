import 'package:flutter/material.dart';

import '../../core/extensions/context_extension.dart';
import '../../features/auth/presentation/layouts/auth_layout.dart';
import '../constants/app_colors.dart';
import '../constants/app_texts.dart';
import 'alert_card.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertCard(
      icon: Icons.info_rounded,
      color: AppColors.red,
      title: 'لم تقم بتسجيل الدخول!',
      subtitle: 'هذه العملية تتطلب تسجيل الدخول',
      confirmLabel: AppTexts.login,
      onConfirmPressed: (_) => context.pushReplacement(const AuthLayout()),
    );
  }
}
