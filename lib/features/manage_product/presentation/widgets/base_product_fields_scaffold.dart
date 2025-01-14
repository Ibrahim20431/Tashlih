import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/globals.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/pick_image_widget.dart';
import '../../../../core/widgets/validator_dropdown.dart';
import '../../../add_order/controllers/providers/companies_provider.dart';
import '../../../add_order/controllers/providers/parts_provider.dart';
import '../../../auth/data/models/id_name_model.dart';
import '../../../auth/presentation/widgets/future_dropdown.dart';
import '../../../product_details/data/models/product_model.dart';
import '../../../my_orders/data/repositories/order_repository.dart';
import '../../data/models/base_product_model.dart';
import 'note_text_field.dart';

class BaseProductFieldsScaffold extends ConsumerStatefulWidget {
  const BaseProductFieldsScaffold({
    super.key,
    required this.title,
    required this.extraFields,
    required this.buttonLabel,
    required this.onPressed,
    this.product,
    this.isImageRequired = true,
  });

  final String title;
  final List<Widget> extraFields;
  final String buttonLabel;
  final void Function(BaseProductModel) onPressed;
  final ProductModel? product;
  final bool isImageRequired;

  @override
  ConsumerState<BaseProductFieldsScaffold> createState() =>
      _BaseProductFieldsWidgetState();
}

class _BaseProductFieldsWidgetState
    extends ConsumerState<BaseProductFieldsScaffold> with ValidationMixin {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController noteController;

  IdNameModel? company;

  late final FutureProvider<List<IdNameModel>> brandsProvider;
  IdNameModel? brand;

  late final List<DropdownMenuItem<String>> models;
  String? model;

  IdNameModel? part;

  final imageProvider = StateProvider<File?>((_) => null);

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    final now = DateTime.now();
    models = [
      for (int y = 1980; y <= now.year; y++)
        DropdownMenuItem(value: '$y', child: Text('$y')),
    ];

    nameController = TextEditingController(text: product?.name);
    noteController = TextEditingController(text: product?.note);

    company = product?.company;
    brand = product?.brand;
    model = product?.model;
    part = product?.part;

    brandsProvider = FutureProvider<List<IdNameModel>>((ref) {
      final repo = ref.read(orderRepoProvider);
      if (company != null) return repo.getBrands(company!.id!);
      return [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScaffold(
        title: widget.title,
        body: Form(
          key: formKey,
          child: ListView(
            addAutomaticKeepAlives: true,
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            children: [
              CustomTextField(
                controller: nameController,
                labelText: 'اسم المنتج',
                prefixIcon: Icons.label_outline_rounded,
                validator: (val) => requiredValidation(val, 'اسم المنتج'),
              ),
              const SizedBox(height: 16),
              FutureDropdown(
                hintText: 'الشركة',
                value: company,
                itemsProvider: companiesProvider,
                onChanged: (val) {
                  brand = null;
                  company = val;
                  ref.invalidate(brandsProvider);
                },
                icon: Icons.factory_outlined,
                validator: (val) => requiredSelectValidation(val, 'الشركة'),
                keepAlive: true,
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (_, WidgetRef ref, __) {
                  final brandsAsync = ref.watch(brandsProvider);
                  return FutureDropdown(
                    hintText: 'الماركة',
                    value: brand,
                    itemsProvider: brandsProvider,
                    onChanged: (val) => brand = val,
                    icon: Icons.car_rental_outlined,
                    validator: (val) =>
                        requiredSelectValidation(val, 'الماركة'),
                    onTap: () {
                      if (company == null) {
                        context.showErrorBar('يجب اختيار الشركة أولاً');
                      } else if (brandsAsync.value!.isEmpty) {
                        context.showErrorBar(
                            'لا توجد ماركات لشركة ${company?.name}');
                      }
                    },
                    keepAlive: true,
                  );
                },
              ),
              const SizedBox(height: 16),
              ValidatorDropdown(
                labelText: 'الموديل',
                value: model,
                items: models,
                onChanged: (val) => model = val,
                prefixIcon: Icons.date_range_outlined,
                validator: (val) => requiredSelectValidation(val, 'الموديل'),
                keepAlive: true,
              ),
              const SizedBox(height: 16),
              FutureDropdown(
                hintText: 'نوع القطعة',
                value: part,
                itemsProvider: partsProvider,
                onChanged: (val) => part = val,
                icon: Icons.settings_outlined,
                validator: (val) => requiredSelectValidation(val, 'نوع القطعة'),
                keepAlive: true,
              ),
              const SizedBox(height: 16),
              ...widget.extraFields,
              const SizedBox(height: 16),
              NoteTextField(noteController),
              const SizedBox(height: 16),
              PickImageWidget(
                title: 'أضف صورة للقطعة',
                imageProvider: imageProvider,
                imageUrl: widget.product?.image,
                aspectRatio: productImageAspectRatio,
                flex: 2,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final image = ref.read(imageProvider)?.path;

                  final imageAdded = !widget.isImageRequired ||
                      (image != null || widget.product != null);

                  if (formKey.currentState!.validate() && imageAdded) {
                    final product = BaseProductModel(
                      name: nameController.text,
                      company: company!,
                      brand: brand!,
                      model: model!,
                      part: part!,
                      image: image,
                      note: noteController.text,
                    );
                    widget.onPressed(product);
                  } else if (!imageAdded) {
                    context.showErrorBar('يرجى إضافة صورة القطعة');
                  }
                },
                child: Text(widget.buttonLabel),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    noteController.dispose();
  }
}
