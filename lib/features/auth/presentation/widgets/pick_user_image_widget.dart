import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/image_picker_service.dart';

class PickUserImageWidget extends ConsumerWidget {
  const PickUserImageWidget({
    super.key,
    this.imageUrl,
    required this.imageProvider,
  });

  final String? imageUrl;
  final StateProvider<File?> imageProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(imageProvider);
    return Center(
      child: GestureDetector(
        onTap: () async {
          final imagePicker = ImagePickerService();
          final file = await imagePicker.pickGalleryImage(maxSizeInMB: 3);
          if (file != null) {
            ref.read(imageProvider.notifier).state = file;
          }
        },
        child: SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(image),
                      radius: 50,
                    )
                  : DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(
                          side: BorderSide(color: AppColors.grey),
                        ),
                        image: imageUrl != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: const SizedBox(
                        height: 100,
                        width: 100,
                        child: Icon(Icons.image_rounded, size: 35),
                      ),
                    ),
              Positioned(
                bottom: 2,
                left: 2,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: primaryColor[300],
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 18,
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
