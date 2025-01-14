import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/circular_loading_widget.dart';
import '../../../core/widgets/retry_widget.dart';
import '../../product_details/presentation/widgets/product_details_scaffold.dart';
import '../../manage_product/presentation/views/edit_product_view.dart';
import '../../profile/notifiers/profile_notifier.dart';
import '../../store_details/presentation/widgets/store_details_scaffold.dart';
import '../../store_details/presentation/widgets/product_widget.dart';
import '../providers/my_store_provider.dart';

class MyStoreView extends ConsumerWidget {
  const MyStoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeAsync = ref.watch(myStoreProvider);
    return storeAsync.when(
      skipLoadingOnRefresh: false,
      data: (store) => StoreDetailsScaffold(
        store,
        hasChatButton: false,
        itemBuilder: (product) => ProductWidget(
          store: store,
          product: product,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionIconButton(
                icon: Icons.edit_rounded,
                color: primaryColor,
                onPressed: () => context.push(EditProductView(product)),
              ),
              const SizedBox(width: 8),
              _ActionIconButton(
                icon: Icons.clear_rounded,
                color: Colors.redAccent,
                onPressed: () {
                  final name = product.name;
                  context.showAlertDialog(
                    icon: CupertinoIcons.delete,
                    color: AppColors.red,
                    title: 'حذف $name',
                    subtitle: 'هل ترغب حقاً بحذف $name؟',
                    confirmLabel: 'حذف',
                    onConfirmPressed: (context) {
                      context.pop();
                      ref
                          .read(profileNotifierProvider.notifier)
                          .deleteProduct(product.id!);
                    },
                    cancelLabel: 'رجوع',
                  );
                },
              ),
            ],
          ),
          onTap: () => context.push(
            ProductDetailsScaffold(store: store, chop: product),
          ),
        ),
      ),
      error: (error, _) => Scaffold(
        body: AppScaffold(
          title: 'متجري',
          body: RetryWidget(
            error: error,
            onPressed: () => ref.invalidate(myStoreProvider),
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: AppScaffold(
          title: 'متجري',
          body: CircularLoadingWidget(),
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
