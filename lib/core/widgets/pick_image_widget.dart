import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class PickImageWidget extends ConsumerWidget {
  const PickImageWidget({
    super.key,
    required this.title,
    this.imageUrl,
    required this.imageProvider,
    this.aspectRatio = 1,
    this.flex = 1,
    this.fit = BoxFit.contain,
  });

  final String title;
  final String? imageUrl;
  final StateProvider<File?> imageProvider;
  final int flex;
  final double aspectRatio;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final xFile = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      if (xFile != null) {
                        ref.read(imageProvider.notifier).state = File(
                          xFile.path,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    onPressed: () async {
                      final xFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (xFile != null) {
                        ref.read(imageProvider.notifier).state = File(
                          xFile.path,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.image_rounded,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: flex,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radius5,
                  ),
                  child: ColoredBox(
                    color: AppColors.lightGrey,
                    child: Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final image = ref.watch(imageProvider);
                        if (image != null) {
                          return Image.file(image, fit: fit);
                        } else if (imageUrl != null) {
                          return CachedNetworkImage(imageUrl: imageUrl!);
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
