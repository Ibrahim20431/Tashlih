import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/utils/helpers/check_login_navigation.dart';
import '../../../add_order/presentation/views/add_order_view.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../manage_product/presentation/views/add_product_view.dart';

class FAB extends ConsumerWidget {
  const FAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    return FloatingActionButton(
      backgroundColor: primaryColor,
      elevation: 0,
      onPressed: () => checkLoginNavigation(
        user,
        user?.type == UserType.client
            ? const AddOrderView()
            : const AddProductView(),
      ),
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add_rounded,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
