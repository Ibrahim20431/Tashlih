import 'package:flutter/material.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_texts.dart';
import '../../home/presentation/widgets/stores_with_search_widget.dart';
import '../providers/providers.dart';

class SpecializedCentersView extends StatelessWidget {
  const SpecializedCentersView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppTexts.specializedCenters,
      body: Padding(
        padding: const EdgeInsets.only(top: AppDimensions.screenPadding),
        child: StoresWithSearchWidget(
          storesProvider: specializedCentersProvider,
          storesFiltersProvider: specializedCentersFiltersProvider,
        ),
      ),
    );
  }
}
