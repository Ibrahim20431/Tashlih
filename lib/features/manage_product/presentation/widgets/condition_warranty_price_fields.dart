import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validation_mixin.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/price_text_field.dart';
import '../../../../core/widgets/validator_dropdown.dart';

class ConditionWarrantyPriceFields extends StatefulWidget {
  const ConditionWarrantyPriceFields({
    super.key,
    required this.warrantyController,
    required this.priceController,
    required this.condition,
    required this.onConditionChanged,
    required this.period,
    required this.onPeriodChanged,
    required this.isPriceRequired,
  });

  final TextEditingController warrantyController;
  final TextEditingController priceController;
  final String condition;
  final void Function(String?) onConditionChanged;
  final String period;
  final void Function(String?) onPeriodChanged;
  final bool isPriceRequired;

  @override
  State<ConditionWarrantyPriceFields> createState() =>
      _ConditionWarrantyPriceFieldsState();
}

class _ConditionWarrantyPriceFieldsState
    extends State<ConditionWarrantyPriceFields> with ValidationMixin {
  final List<DropdownMenuItem<String>> conditions = const [
    DropdownMenuItem(
      value: 'used',
      child: Text('مستخدم'),
    ),
    DropdownMenuItem(
      value: 'new',
      child: Text('جديد'),
    ),
  ];

  late final periodProvider = StateProvider((_) => widget.period);
  final List<DropdownMenuItem<String>> periods = const [
    DropdownMenuItem(value: 'سنة', child: Text('سنة')),
    DropdownMenuItem(value: 'شهر', child: Text('شهر')),
    DropdownMenuItem(value: 'يوم', child: Text('يوم')),
    DropdownMenuItem(value: 'غير محدد', child: Text('غير محدد')),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValidatorDropdown(
          labelText: 'الحالة',
          value: widget.condition,
          items: conditions,
          onChanged: widget.onConditionChanged,
          prefixIcon: Icons.car_crash_outlined,
          validator: (val) => requiredSelectValidation(val, 'الحالة'),
        ),
        const SizedBox(height: 16),
        // Consumer(
        //   builder: (_, WidgetRef ref, __) {
        //     final period = ref.watch(periodProvider);
        //     final hasWarranty = period != 'بدون ضمان';
        //     return Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         if (hasWarranty) ...[
        //           Expanded(
        //             child: CustomTextField(
        //               controller: widget.warrantyController,
        //               labelText: 'الضمان',
        //               prefixIcon: Icons.local_police_outlined,
        //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        //               keyboardType: TextInputType.number,
        //               validator: (val) => requiredValidation(val, 'الضمان'),
        //             ),
        //           ),
        //           const SizedBox(width: 16),
        //         ],
        //         Expanded(
        //           child: ValidatorDropdown(
        //             value: perio
        //             items: periods,
        //             prefixIcon:
        //                 hasWarranty ? null : Icons.local_police_outlined,
        //             onChanged: (val) {
        //               widget.warrantyController.clear();
        //               ref.read(periodProvider.notifier).state = val!;
        //               widget.onPeriodChanged(val);
        //             },
        //           ),
        //         )
        //       ],
        //     );
        //   },
        // ),
        // const SizedBox(height: 16),
        PriceTextField(
          controller: widget.priceController,
          isRequired: widget.isPriceRequired,
        ),
      ],
    );
  }
}
