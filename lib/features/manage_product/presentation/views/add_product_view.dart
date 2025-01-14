import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/notifiers/profile_notifier.dart';
import '../widgets/manage_product_scaffold.dart';

class AddProductView extends ConsumerWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ManageProductScaffold(
      title: 'إضافة منتج',
      buttonLabel: 'إضافة',
      onPressed: ref.read(profileNotifierProvider.notifier).addProduct,
    );
  }
}
