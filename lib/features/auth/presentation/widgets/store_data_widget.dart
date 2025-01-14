import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/pick_image_widget.dart';
import '../../../../core/widgets/validator_dropdown.dart';
import '../../controllers/notifiers/auth_notifier.dart';
import '../../controllers/providers/car_brands_provider.dart';
import '../../data/models/id_name_model.dart';
import '../../data/models/trader_data_validation_model.dart';
import '../widgets/future_dropdown.dart';

class StoreDataWidget extends ConsumerStatefulWidget {
  const StoreDataWidget({
    super.key,
    this.store,
    required this.buttonLabel,
    required this.onSubmitPressed,
  });

  final TraderDataValidationModel? store;
  final String buttonLabel;
  final void Function(TraderDataValidationModel) onSubmitPressed;

  @override
  ConsumerState<StoreDataWidget> createState() => _StoreDataWidgetState();
}

class _StoreDataWidgetState extends ConsumerState<StoreDataWidget>
    with ValidationMixin {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController storeName;
  late final TextEditingController mapUrl;
  late final TextEditingController registrationNumber;
  late final TextEditingController licenseNumber;
  late final TextEditingController idNumber;

  late final StateProvider<StoreType> typeProvider;
  late final StateProvider<List<IdNameModel>> brandsProvider;

  final imageProvider = StateProvider<File?>((_) => null);

  TraderDataValidationModel trader = const TraderDataValidationModel();
  TraderDataValidationModel apiValidation = const TraderDataValidationModel();

  @override
  void initState() {
    super.initState();
    final store = widget.store;
    storeName = TextEditingController(text: store?.store);
    mapUrl = TextEditingController(text: store?.mapUrl);
    registrationNumber = TextEditingController(text: store?.registrationNumber);
    licenseNumber = TextEditingController(text: store?.licenseNumber);
    idNumber = TextEditingController(text: store?.idNumber);
    typeProvider = StateProvider(
      (_) => StoreType.values[store?.isSpecialStore ?? 0],
    );
    brandsProvider = StateProvider<List<IdNameModel>>(
      (_) => store?.categories ?? [],
    );
  }

  @override
  void dispose() {
    storeName.dispose();
    mapUrl.dispose();
    registrationNumber.dispose();
    licenseNumber.dispose();
    idNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenAuthState();
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
            vertical: 26,
          ),
          children: [
            CustomTextField(
              controller: storeName,
              prefixIcon: Icons.store_outlined,
              labelText: AppTexts.storeName,
              keyboardType: TextInputType.name,
              validator: (val) {
                final validation = requiredValidation(val, 'اسم المتجر');
                if (validation == null) {
                  if (val?.trim() == trader.store?.trim()) {
                    return apiValidation.store;
                  }
                }
                return validation;
              },
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (_, WidgetRef ref, __) {
                final type = ref.watch(typeProvider);
                return Column(
                  children: [
                    ValidatorDropdown(
                      value: type,
                      labelText: AppTexts.unSpecialist,
                      prefixIcon: Icons.car_crash_outlined,
                      items: const [
                        DropdownMenuItem(
                          value: StoreType.notSpecial,
                          child: Text(AppTexts.unSpecialist),
                        ),
                        DropdownMenuItem(
                          value: StoreType.special,
                          child: Text(AppTexts.specialist),
                        ),
                      ],
                      onChanged: (val) {
                        if (val == StoreType.notSpecial) {
                          ref.invalidate(brandsProvider);
                        }
                        ref.read(typeProvider.notifier).state = val!;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (type == StoreType.notSpecial)
                      ValidatorDropdown(
                        labelText: AppTexts.all,
                        prefixIcon: Icons.car_rental_outlined,
                      )
                    else
                      Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final selectedBrands = ref.watch(brandsProvider);
                          return Column(
                            children: [
                              FutureDropdown(
                                itemsProvider: carBrandsProvider,
                                icon: Icons.car_rental_outlined,
                                hintText: AppTexts.choseCompany,
                                showValidator: selectedBrands.isEmpty,
                                exceedItems: selectedBrands,
                                validator: (val) =>
                                    requiredSelectValidation(val, 'الشركة'),
                                onChanged: (val) {
                                  final count = ref.read(brandsProvider).length;
                                  if (count != 3) {
                                    ref.read(brandsProvider.notifier).update(
                                          (state) => [...state, val!],
                                        );
                                  } else {
                                    context.showErrorBar(
                                      'يمكنك اختيار 3 شركات كحد أقصى',
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              ...List.generate(
                                selectedBrands.length,
                                (index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(
                                      vertical: VisualDensity.minimumDensity,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      right: 20,
                                      left: 1,
                                    ),
                                    leading: Text('${index + 1}'),
                                    title: Text(selectedBrands[index].name),
                                    trailing: IconButton(
                                      onPressed: () {
                                        ref
                                            .read(brandsProvider.notifier)
                                            .update(
                                              (state) => [
                                                ...state.where(
                                                  (brand) =>
                                                      brand !=
                                                      selectedBrands[index],
                                                )
                                              ],
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: mapUrl,
              prefixIcon: Icons.my_location_outlined,
              labelText: AppTexts.storeLocationLink,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: registrationNumber,
              prefixIcon: Icons.event_available_rounded,
              labelText: AppTexts.registrationNumber,
              maxLength: 10,
              validator: (val) {
                final validation = registrationValidation(val);
                if (validation == null) {
                  if (val?.trim() == trader.registrationNumber?.trim()) {
                    return apiValidation.registrationNumber;
                  }
                }
                return validation;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: licenseNumber,
              prefixIcon: Icons.featured_play_list_outlined,
              labelText: AppTexts.licenceNumber,
              maxLength: 10,
              validator: (val) {
                final validation = licenseValidation(val);
                if (validation == null) {
                  if (val?.trim() == trader.licenseNumber?.trim()) {
                    return apiValidation.licenseNumber;
                  }
                }
                return validation;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: idNumber,
              prefixIcon: Icons.perm_contact_cal_outlined,
              labelText: 'رقم هوية المالك',
              maxLength: 10,
              validator: (val) {
                final validation = userIDValidation(val);
                if (validation == null) {
                  if (val?.trim() == trader.idNumber?.trim()) {
                    return apiValidation.idNumber;
                  }
                }
                return validation;
              },
            ),
            const SizedBox(height: 16),
            PickImageWidget(
              title: 'أضف صورة من السجل التجاري',
              imageUrl: widget.store?.image,
              imageProvider: imageProvider,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final imageAdded =
                    ref.read(imageProvider) != null || widget.store != null;
                if (formKey.currentState!.validate() && imageAdded) {
                  trader = TraderDataValidationModel(
                    store: storeName.text.trim(),
                    mapUrl: mapUrl.text.trim(),
                    isSpecialStore: ref.read(typeProvider).index,
                    categories: ref.read(brandsProvider),
                    registrationNumber: registrationNumber.text,
                    licenseNumber: licenseNumber.text,
                    idNumber: idNumber.text,
                    image: ref.read(imageProvider)?.path,
                  );
                  widget.onSubmitPressed(trader);
                } else if (!imageAdded) {
                  context.showErrorBar('يرجى إضافة صورة السجل التجاري');
                }
              },
              child: Text(widget.buttonLabel),
            ),
          ],
        ),
      ),
    );
  }

  void _listenAuthState() {
    ref.listen(authNotifierProvider, (_, state) {
      if (state.error is TraderDataValidationModel) {
        apiValidation = state.error as TraderDataValidationModel;
        formKey.currentState!.validate();
      }
    });
  }
}
