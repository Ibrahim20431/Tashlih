import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget(
    this.imageUrl, {
    super.key,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppDimensions.radius20),
    ),
    this.size = double.infinity,
    this.height = 0,
    this.width = 0,
  });

  final String imageUrl;
  final BorderRadiusGeometry borderRadius;
  final double size;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: height == 0 ? size : height,
        width: width == 0 ? size : width,
        // height: size,
      ),
    );
  }
}
