import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../chats/controllers/notifiers/start_chat_notifier.dart';
import '../../../chats/presentation/views/chat_view.dart';
import '../../../product_details/presentation/views/product_details_view.dart';
import '../../data/models/store_model.dart';
import '../widgets/store_details_scaffold.dart';
import '../widgets/product_widget.dart';

class StoreDetailsView extends ConsumerWidget {
  const StoreDetailsView(this.store, {super.key});

  final StoreModel store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenStartChatState(context, ref);
    return StoreDetailsScaffold(
      store,
      hasChatButton: true,
      itemBuilder: (product) => ProductWidget(
        store: store,
        product: product,
        onTap: () => context.push(ProductDetailsView(store, product)),
      ),
    );
  }

  void _listenStartChatState(BuildContext context, WidgetRef ref) {
    ref.listen(startChatNotifierProvider(FirebaseCollections.chats),
        (_, state) {
      if (state.hasValue) context.push(ChatView(state.requireValue));
    });
  }
}
