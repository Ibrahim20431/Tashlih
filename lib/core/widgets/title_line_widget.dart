import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class TitleLineWidget extends StatelessWidget {
  const TitleLineWidget({
    super.key,
    required this.height,
    required this.width,
    this.color = primaryColor,
  });

  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
