import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/key_enums.dart';
import '../../controllers/notifiers/active_status_notifier.dart';

class ChatImage extends StatelessWidget {
  const ChatImage({
    super.key,
    required this.userId,
    required this.radius,
    required this.image,
    required this.bottomPosition,
  });

  final int userId;
  final double radius;
  final String image;
  final double bottomPosition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: primaryColor.withOpacity(.5),
          foregroundImage: CachedNetworkImageProvider(image),
        ),
        Consumer(
          builder: (_, WidgetRef ref, __) {
            final presence = ref.watch(activeStatusNotifierProvider(userId));
            return PositionedDirectional(
              end: 0,
              bottom: bottomPosition,
              child: CircleAvatar(
                radius: 5,
                backgroundColor: presence == UserPresence.online
                    ? Colors.green
                    : Colors.grey,
              ),
            );
          },
        )
      ],
    );
  }
}
