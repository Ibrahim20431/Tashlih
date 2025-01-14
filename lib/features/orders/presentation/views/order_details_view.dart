import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../add_order/controllers/notifiers/add_order_notifier.dart';
import '../../../chats/controllers/notifiers/start_chat_notifier.dart';
import '../../../chats/presentation/views/chat_view.dart';
import '../../../product_details/presentation/widgets/product_details_widget.dart';
import '../../../product_details/presentation/widgets/product_info_widget.dart';
import '../../../my_orders/data/models/order_model.dart';
import '../../../offers/controllers/providers/search_offers_provider.dart';
import '../../../order_offers/data/models/search_model.dart';
import '../../../manage_product/presentation/widgets/condition_warranty_price_fields.dart';
import '../../../manage_product/presentation/widgets/note_text_field.dart';
import '../widgets/open_chat_icon.dart';

class OrderDetailsView extends ConsumerStatefulWidget {
  const OrderDetailsView(this.order, {super.key});

  final OrderModel order;

  @override
  ConsumerState<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends ConsumerState<OrderDetailsView> {
  final formKey = GlobalKey<FormState>();

  final warrantyController = TextEditingController();
  final priceController = TextEditingController();
  final noteController = TextEditingController();

  String condition = 'used';
  String period = 'سنة';

  @override
  Widget build(BuildContext context) {
    _listenOrderState();
    _listenStartChatState(context, ref);
    final order = widget.order;
    final isOffered = order.isOffered!;
    return Scaffold(
      body: AppScaffold(
        title: 'التفاصيل',
        body: Form(
          key: formKey,
          child: ProductDetailsWidget(
            product: widget.order,
            trailing: OpenChatIcon(order.chat),
            children: [
              ProductInfoWidget(
                icon: Icons.settings_outlined,
                label: 'نوع القطعة',
                value: widget.order.part.name,
              ),
              const SizedBox(height: 16),
              ProductInfoWidget(
                icon: Icons.local_shipping_outlined,
                label: 'موقع الإستلام',
                value: order.city,
              ),
              Row(
                children: [
                  const Expanded(child: CustomDivider(height: 64)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InfoCard(
                      info: isOffered ? 'تم تقديم عرض من قبل' : 'تقديم عرض',
                      color: primaryColor[300]!.withOpacity(.08),
                      style: TextStyles.mediumMedium,
                    ),
                  ),
                  const Expanded(child: CustomDivider(height: 64)),
                ],
              ),
              if (!isOffered)
                Column(
                  children: [
                    ConditionWarrantyPriceFields(
                      warrantyController: warrantyController,
                      priceController: priceController,
                      condition: condition,
                      onConditionChanged: (val) => condition = val!,
                      period: period,
                      onPeriodChanged: (val) => period = val!,
                      isPriceRequired: true,
                    ),
                    const SizedBox(height: 16),
                    NoteTextField(noteController),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ref
                              .read(orderNotifierProvider.notifier)
                              .addOrderOffer(
                                orderId: widget.order.id!,
                                price: priceController.text,
                                warranty: '${warrantyController.text} $period',
                                note: noteController.text,
                                condition: condition,
                              );
                        }
                      },
                      child: const Text('ارسال العرض'),
                    ),
                    const SizedBox(height: 24),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  void _listenOrderState() {
    ref.listen(orderNotifierProvider, (_, state) {
      if (state.hasData) {
        ref.read(searchOffersProvider.notifier).state = SearchModel('');
        final order = widget.order;
        order.isOffered = true;
        ref.read(order.offersCountProvider.notifier).update(
              (count) => count + 1,
            );
        context.pop();
      }
    });
  }

  void _listenStartChatState(BuildContext context, WidgetRef ref) {
    ref.listen(startChatNotifierProvider(FirebaseCollections.chats),
        (_, state) {
      if (state.hasValue) context.push(ChatView(state.requireValue));
    });
  }

  @override
  void dispose() {
    super.dispose();
    warrantyController.dispose();
    priceController.dispose();
    noteController.dispose();
  }
}
