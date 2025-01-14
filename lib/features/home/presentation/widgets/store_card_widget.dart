import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/network_image_widget.dart';
import '../../../store_details/presentation/views/store_details_view.dart';
import '../../../store_details/data/models/store_model.dart';

class StoreCardWidget extends ConsumerWidget {
  const StoreCardWidget(this.store, {super.key});

  final StoreModel store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push(StoreDetailsView(store)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(AppDimensions.radius20),
        ),
        padding: const EdgeInsets.all(AppDimensions.padding8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: NetworkImageWidget(store.image)),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: AutoSizeText(
                      store.name,
                      style: TextStyles.largeBold.copyWith(
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                      ),
                      Text(
                        store.city,
                        style: TextStyles.xSmallBold.copyWith(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  RatingBarIndicator(
                    rating: store.rate,
                    itemBuilder: (_, __) => const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 15.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
