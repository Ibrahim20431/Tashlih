import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../store_details/data/models/store_model.dart';
import '../../../store_details/presentation/widgets/start_chat_button.dart';
import '../../data/models/product_model.dart';
import '../widgets/product_details_scaffold.dart';

class ProductDetailsView extends ConsumerWidget {
  const ProductDetailsView(this.store, this.product, {super.key});

  final StoreModel store;
  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductDetailsScaffold(
      store: store,
      chop: product,
      actionButton: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: StartChatButton(store.toChat())
      ),
    );
  }
}
