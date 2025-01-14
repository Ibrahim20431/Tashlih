import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../chats/data/models/chat_model.dart';
import '../../../chats/presentation/widgets/conversation_widget.dart';
import '../../../product_details/presentation/widgets/product_info_widget.dart';
import '../../../product_details/presentation/widgets/client_product_details_widget.dart';
import '../../../offers/models/order_offer_model.dart';
import '../../../rate_trader/notifiers/rate_trader_notifier.dart';
import '../../../rate_trader/widgets/rate_trader_dialog.dart';

class OrderOfferView extends ConsumerWidget {
  OrderOfferView({
    super.key,
    required this.offer,
    required this.chat,
    required this.price,
    required this.button,
    this.store = const SizedBox(),
  });

  final OrderOfferModel offer;
  final ChatModel chat;
  final Widget price;
  final Widget button;
  final Widget store;

  late final _offerOpenProvider = StateProvider<bool>((ref) {
    final offerState = ref.watch(offer.offerNotifierProvider);
    return offerState.status != OrderOfferStatus.completed;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chop = offer.product;
    _listenOfferState(context, ref);
    _listenRateState(context, ref);
    return Scaffold(
      body: AppScaffold(
        title: 'تفاصيل العرض',
        actions: [
          Consumer(builder: (_, WidgetRef ref, __) {
            final offerOpen = ref.watch(_offerOpenProvider);
            if (offerOpen) {
              return IconButton(
                onPressed:
                    ref.read(offer.offerNotifierProvider.notifier).refreshState,
                icon: const Icon(Icons.refresh_rounded),
              );
            }
            return const SizedBox.shrink();
          })
        ],
        body: ClientProductDetailsWidget(
          product: chop,
          store: store,
          price: price,
          bottom: ColoredBox(
            color: AppColors.lightGrey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: context.height * .65,
                child: ConversationWidget(
                  chat,
                  FirebaseCollections.offerChats,
                  orderName: chop.name,
                ),
              ),
            ),
          ),
          children: [
            const SizedBox(height: 16),
            ProductInfoWidget(
              icon: Icons.edit_calendar_rounded,
              label: 'تاريخ العرض',
              value: offer.date,
            ),
            const SizedBox(height: 24),
            button,
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(child: CustomDivider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('المعاملات على العرض'),
                ),
                Expanded(child: CustomDivider()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _listenOfferState(BuildContext context, WidgetRef ref) {
    ref.listen(offer.offerNotifierProvider, (_, state) {
      if (state.status == OrderOfferStatus.completed) {
        if (ref.read(userProvider)!.type == UserType.client) {
          final store = offer.store;
          context.showCustomDialog(
            RateTraderDialog(
              traderId: store.id,
              traderName: store.name,
            ),
            canPop: false,
          );
        }
      }
    });
  }

  void _listenRateState(BuildContext context, WidgetRef ref) {
    ref.listen(rateTraderNotifierProvider, (_, state) {
      if (state.hasError) {
        final store = offer.store;
        double rate = ref.read(rateTraderNotifierProvider.notifier).rateValue;
        context.showCustomDialog(
          RateTraderDialog(
            initialRate: rate,
            traderId: store.id,
            traderName: store.name,
          ),
        );
      }
    });
  }
}
