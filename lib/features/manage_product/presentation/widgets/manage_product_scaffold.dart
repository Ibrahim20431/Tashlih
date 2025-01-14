import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../product_details/data/models/product_model.dart';
import '../../../profile/notifiers/profile_notifier.dart';
import 'condition_warranty_price_fields.dart';
import 'base_product_fields_scaffold.dart';

class ManageProductScaffold extends ConsumerStatefulWidget {
  const ManageProductScaffold({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.onPressed,
    this.product,
  });

  final String title;
  final String buttonLabel;
  final void Function(ProductModel) onPressed;
  final ProductModel? product;

  @override
  ConsumerState<ManageProductScaffold> createState() =>
      _ProductDetailsViewState();
}

class _ProductDetailsViewState extends ConsumerState<ManageProductScaffold>
    with ValidationMixin {
  late final TextEditingController priceController;

  late final TextEditingController warrantyController;

  late String condition;

  late String period;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      final warranty = product.warranty;
      if (product.hasWarranty) {
        final warrantySplit = warranty.split(' ');
        warrantyController = TextEditingController(text: warrantySplit.first);
        period = warrantySplit.last;
      } else {
        warrantyController = TextEditingController();
        period = warranty;
      }

      priceController = TextEditingController(
        text: product.hasPrice ? '${product.price}' : '',
      );
      condition = product.conditionEn;
    } else {
      warrantyController = TextEditingController();
      priceController = TextEditingController();
      period = 'سنة';
      condition = 'used';
    }
  }

  @override
  Widget build(BuildContext context) {
    _listenProfileState();
    return BaseProductFieldsScaffold(
      title: widget.title,
      product: widget.product,
      extraFields: [
        ConditionWarrantyPriceFields(
          warrantyController: warrantyController,
          priceController: priceController,
          condition: condition,
          onConditionChanged: (val) => condition = val!,
          period: period,
          onPeriodChanged: (val) => period = val!,
          isPriceRequired: false,
        ),
      ],
      buttonLabel: widget.buttonLabel,
      onPressed: (baseData) {
        final priceText = priceController.text;
        final product = ProductModel(
          id: widget.product?.id,
          name: baseData.name,
          company: baseData.company,
          brand: baseData.brand,
          model: baseData.model,
          part: baseData.part,
          image: baseData.image,
          note: baseData.note,
          price: priceText.isNotEmpty ? int.parse(priceController.text) : null,
          warranty: '${warrantyController.text} $period',
          conditionEn: condition,
        );
        widget.onPressed(product);
      },
    );
  }

  void _listenProfileState() {
    ref.listen(profileNotifierProvider, (_, state) {
      if (state.hasData) context.pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    warrantyController.dispose();
  }
}
