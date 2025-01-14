import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../../core/widgets/validator_dropdown.dart';
import '../../../auth/controllers/providers/cities_provider.dart';
import '../../../auth/data/models/id_name_model.dart';
import '../../../auth/presentation/widgets/future_dropdown.dart';
import '../../../my_orders/presentation/views/my_orders_view.dart';
import '../../../manage_product/presentation/widgets/base_product_fields_scaffold.dart';
import '../../../my_orders/providers/client_orders_provider.dart';
import '../../../orders/presentation/widgets/commission_dialog.dart';
import '../../controllers/notifiers/add_order_notifier.dart';
import '../../data/models/add_order_data.dart';

class AddOrderView extends ConsumerStatefulWidget {
  const AddOrderView({super.key});

  @override
  ConsumerState<AddOrderView> createState() => _AddOrderViewState();
}

class _AddOrderViewState extends ConsumerState<AddOrderView>
    with ValidationMixin {
  StoreType? storeType;

  IdNameModel? city;

  late AddOrderData _orderData;

  @override
  Widget build(BuildContext context) {
    _listenAddOrderState();
    return BaseProductFieldsScaffold(
      title: 'إضافة طلب',
      isImageRequired: false,
      extraFields: [
        ValidatorDropdown(
          labelText: 'نوع المتجر',
          value: storeType,
          items: const [
            DropdownMenuItem(
              value: null,
              child: Text('الكل'),
            ),
            DropdownMenuItem(
              value: StoreType.notSpecial,
              child: Text('غير متخصص'),
            ),
            DropdownMenuItem(
              value: StoreType.special,
              child: Text('متخصص'),
            ),
          ],
          onChanged: (val) => storeType = val,
          prefixIcon: Icons.store_outlined,
        ),
        const SizedBox(height: 16),
        FutureDropdown(
          itemsProvider: citiesProvider,
          value: city,
          icon: Icons.location_on_outlined,
          hintText: 'موقع استلام الطلب',
          validator: (val) =>
              requiredSelectValidation(val, 'موقع استلام الطلب'),
          onChanged: (val) => city = val,
        ),
      ],
      buttonLabel: 'إضافة',
      onPressed: (baseProduct) {
        ref.read(orderNotifierProvider.notifier).getBank();
        final order = AddOrderData(
          storeType: storeType,
          receivingCity: city!.id!,
          product: baseProduct,
        );
        _orderData = order;
      },
    );
  }

  void _listenAddOrderState() {
    ref.listen(orderNotifierProvider, (_, state) {
      if (state.hasData) {
        final bank = state.data;
        if (bank != null) {
          context.showCustomDialog(
            CommissionDialog(
              bank: bank,
              onPressed: () {
                ref.read(orderNotifierProvider.notifier).addOrder(_orderData);
              },
            ),
          );
        } else {
          ref.invalidate(clientOrdersProvider);
          context.showAlertDialog(
            canPop: false,
            icon: Icons.check_circle_rounded,
            title: 'تم إضافة الطلب',
            subtitle:
                'سيتم عرض طلبك للتجار وسيقدمون العروض لك.\nشاهد العروض المقدمة على طلبك في صفحة حسابي قسم طلباتي.',
            confirmLabel: 'الذهاب لطلباتي',
            onConfirmPressed: (_) {
              context.pop();
              context.pushReplacement(const MyOrdersView());
            },
            cancelLabel: 'حسناً',
            onCancelPressed: context.pop,
          );
        }
      }
    });
  }
}
