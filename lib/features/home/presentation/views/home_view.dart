import 'package:flutter/material.dart';

import '../../../../core/constants/app_texts.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../providers/providers.dart';
import '../widgets/carousels_slider_indicator.dart';
import '../widgets/stores_with_search_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppTexts.stores,
      body: Column(
        children: [
          const CarouselSliderIndicator(),
          const SizedBox(height: 16),
          Expanded(
            child: StoresWithSearchWidget(
              storesProvider: storesProvider,
              storesFiltersProvider: cityFiltersProvider,
            ),
          )
        ],
      ),
    );
  }
}
