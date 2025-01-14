import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/circular_loading_widget.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../../../auth/controllers/notifiers/auth_notifier.dart';
import '../../../auth/presentation/widgets/store_data_widget.dart';
import '../../controllers/providers/my_store_provider.dart';

class EditStoreView extends ConsumerWidget {
  const EditStoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeDetailsAsync = ref.watch(myStoreDetailsProvider);
    _listenAuthState(context, ref);
    return Scaffold(
      body: AppScaffold(
          title: 'متجري',
          body: storeDetailsAsync.when(
            skipLoadingOnRefresh: false,
            data: (store) => StoreDataWidget(
              store: store,
              buttonLabel: 'حفظ',
              onSubmitPressed:
                  ref.read(authNotifierProvider.notifier).updateStore,
            ),
            error: (error, _) => RetryWidget(
              error: error,
              onPressed: () => ref.invalidate(myStoreDetailsProvider),
            ),
            loading: () => const CircularLoadingWidget(),
          )),
    );
  }

  void _listenAuthState(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (_, state) {
      if (state.hasData) context.pop();
    });
  }
}
