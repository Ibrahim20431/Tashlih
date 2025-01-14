import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/network_image_widget.dart';
import '../../providers/slider_images_provider.dart';

class CarouselSliderIndicator extends ConsumerStatefulWidget {
  const CarouselSliderIndicator({super.key});

  @override
  ConsumerState<CarouselSliderIndicator> createState() =>
      _CarouselSliderIndicatorState();
}

class _CarouselSliderIndicatorState
    extends ConsumerState<CarouselSliderIndicator> {
  int activeIndex = 0;
  final carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final imagesAsync = ref.watch(sliderImagesProvider);
    final hasValue = imagesAsync.hasValue;
    final images = hasValue ? imagesAsync.requireValue : [''];
    final isMoreThan1 = images.length > 1;
    if (!hasValue || (hasValue && images.isNotEmpty)) {
      return Column(
        children: [
          const SizedBox(height: AppDimensions.screenPadding),
          CarouselSlider.builder(
            carouselController: carouselController,
            options: CarouselOptions(
              autoPlay: isMoreThan1,
              aspectRatio: 3 / 1,
              enlargeCenterPage: true,
              enableInfiniteScroll: isMoreThan1,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, _) => setState(
                () => activeIndex = index,
              ),
            ),
            itemCount: images.length,
            itemBuilder: (_, index, __) => hasValue
                ? NetworkImageWidget(images[index])
                : Image.asset(PngIcons.tashleh),
          ),
          const SizedBox(height: AppDimensions.padding8),
          AnimatedSmoothIndicator(
            onDotClicked: carouselController.jumpToPage,
            activeIndex: activeIndex,
            count: images.length,
            effect: JumpingDotEffect(
              dotWidth: 11,
              dotHeight: 8,
              spacing: 4,
              activeDotColor: primaryColor[300]!,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
