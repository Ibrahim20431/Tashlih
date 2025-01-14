import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';

class ImageGalleryView extends ConsumerWidget {
  const ImageGalleryView(this.image, this.isFile, {super.key});

  final String image;
  final bool isFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Padding(
        padding: EdgeInsets.only(bottom: context.navigationBarHeight),
        child: Center(
          child: isFile
              ? Image.file(File(image))
              : CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (_, __) => const Icon(Icons.image_rounded),
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.broken_image_rounded,
                    color: Colors.red,
                  ),
                ),
        ),
      ),
    );
  }
}
