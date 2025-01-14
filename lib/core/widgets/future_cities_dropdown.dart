import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extension.dart';
import '../../features/auth/controllers/providers/cities_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/text_styles.dart';
import '../models/search_params_model.dart';
import 'circular_loading_widget.dart';
import 'custom_dropdown.dart';

class FutureCitiesDropdown extends ConsumerStatefulWidget {
  const FutureCitiesDropdown({super.key, required this.filtersProvider});

  final StateProvider<SearchParamsModel> filtersProvider;

  @override
  ConsumerState<FutureCitiesDropdown> createState() =>
      _FutureCitiesDropdownState();
}

class _FutureCitiesDropdownState extends ConsumerState<FutureCitiesDropdown> {
  int? cityId;

  @override
  Widget build(BuildContext context) {
    final citiesAsync = ref.watch(citiesProvider);
    return citiesAsync.when(
      skipLoadingOnRefresh: false,
      data: (cities) {
        final items = [
          const DropdownMenuItem(
            value: null,
            child: AutoSizeText(
              'الكل',
              maxLines: 1,
              style: TextStyle(color: primaryColor),
            ),
          ),
          const DropdownMenuItem(
            value: 0,
            child: AutoSizeText(
              'عدة مدن',
              maxLines: 1,
              style: TextStyle(color: primaryColor),
            ),
          ),
          for (final city in cities)
            DropdownMenuItem(
              value: city.id,
              child: AutoSizeText(
                city.name,
                maxLines: 1,
                style: const TextStyle(color: primaryColor),
              ),
            )
        ];
        return CustomDropdown(
          value: cityId,
          height: AppDimensions.height41,
          items: items,
          style: TextStyles.smallBold,
          hintStyle: TextStyles.smallBold,
          borderRadius: AppDimensions.radius5,
          borderColor: primaryColor,
          onTap: () {
            List<int> selectedCities = [
              ...ref.read(widget.filtersProvider).cities
            ];
            final providers = List.generate(
              cities.length,
              (index) => StateProvider(
                (_) => selectedCities.contains(cities[index].id),
              ),
            );
            final allProvider = StateProvider(
              (ref) => selectedCities.length == cities.length,
            );
            context.showBottomSheet(
              title: 'المنطقة',
              okLabel: 'تطبيق',
              onOkPressed: () {
                ref.read(widget.filtersProvider.notifier).update(
                      (filter) => filter.copyWith(newCities: selectedCities),
                    );
                final isAllSelected = ref.read(allProvider);
                setState(() {
                  if (selectedCities.length == 1) {
                    cityId = selectedCities.first;
                  } else if (selectedCities.isEmpty || isAllSelected) {
                    cityId = null;
                  } else {
                    cityId = 0;
                  }
                });
                context.pop();
              },
              child: Column(
                children: [
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final selected = ref.watch(allProvider);
                      return CheckboxListTile(
                        value: selected,
                        onChanged: (val) {
                          if (val!) {
                            selectedCities = cities.map((c) => c.id!).toList();
                            for (final provider in providers) {
                              ref.read(provider.notifier).state = true;
                            }
                          } else {
                            selectedCities = [];
                            for (final provider in providers) {
                              ref.read(provider.notifier).state = false;
                            }
                          }
                          ref.read(allProvider.notifier).state = val;
                        },
                        title: const Text('كل المدن'),
                      );
                    },
                  ),
                  const Divider(height: 0),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final provider = providers[index];
                      return Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final selected = ref.watch(provider);
                          final city = cities[index];
                          return CheckboxListTile(
                            value: selected,
                            onChanged: (val) {
                              if (val!) {
                                selectedCities.add(city.id!);
                              } else {
                                selectedCities.remove(city.id);
                              }
                              ref.read(provider.notifier).state = val;
                            },
                            title: Text(city.name),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemCount: cities.length,
                  )
                ],
              ),
            );
          },
        );
      },
      error: (_, __) => CustomDropdown(
        height: AppDimensions.height41,
        borderRadius: AppDimensions.radius5,
        borderColor: primaryColor,
        suffixIcon: const Icon(
          Icons.refresh_rounded,
          color: primaryColor,
        ),
        hintText: 'الكل',
        hintStyle: TextStyles.smallBold,
        onTap: () => ref.invalidate(citiesProvider),
      ),
      loading: () => const CustomDropdown(
        height: AppDimensions.height41,
        borderRadius: AppDimensions.radius5,
        borderColor: primaryColor,
        suffixIcon: CircularLoadingWidget(size: 20, color: primaryColor),
        hintText: 'الكل',
        hintStyle: TextStyles.smallBold,
      ),
    );
  }
}
