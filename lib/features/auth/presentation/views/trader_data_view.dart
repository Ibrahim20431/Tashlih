import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_texts.dart';
import '../../controllers/notifiers/auth_notifier.dart';
import '../widgets/auth_scaffold_widget.dart';
import '../widgets/store_data_widget.dart';

class TraderDataView extends ConsumerWidget {
  const TraderDataView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthScaffold(
      title: 'تسجيل جديد',
      subtitle: 'بيانات المتجر\nيرجى تعبئة بيانات متجرك',
      child: StoreDataWidget(
        buttonLabel: AppTexts.register,
        onSubmitPressed: ref.read(authNotifierProvider.notifier).traderSignup,
      ),
    );
  }
}
