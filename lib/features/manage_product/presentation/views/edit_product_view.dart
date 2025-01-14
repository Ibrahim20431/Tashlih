import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product_details/data/models/product_model.dart';
import '../../../profile/notifiers/profile_notifier.dart';
import '../widgets/manage_product_scaffold.dart';

class EditProductView extends ConsumerWidget {
  const EditProductView(this.product, {super.key});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ManageProductScaffold(
      title: 'تعديل منتج',
      buttonLabel: 'تعديل',
      onPressed: ref.read(profileNotifierProvider.notifier).updateProduct,
      product: product,
    );
  }
}
