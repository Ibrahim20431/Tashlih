import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/network_image_widget.dart';
import '../../../store_details/data/models/store_model.dart';

class StoreTile extends StatelessWidget {
  const StoreTile(this.store, {super.key, this.onTap});

  final StoreModel store;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            NetworkImageWidget(
              store.image,
              size: 40,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppDimensions.radius10),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: TextStyles.mediumBold.copyWith(
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: primaryColor[300],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      store.city,
                      style: TextStyles.smallBold.copyWith(
                        color: primaryColor[300],
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
