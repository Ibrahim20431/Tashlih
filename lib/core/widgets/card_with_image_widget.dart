import 'package:flutter/widgets.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'network_image_widget.dart';

class CardWithImageWidget extends StatelessWidget {
  const CardWithImageWidget({
    super.key,
    required this.image,
    this.imageSize = 100,
    required this.children,
    required this.onTap,
  });

  final String image;
  final double imageSize;
  final List<Widget> children;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radius16),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              NetworkImageWidget(
                image,
                size: imageSize,
                borderRadius: const BorderRadiusDirectional.horizontal(
                  start: Radius.circular(AppDimensions.radius16),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: children,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
