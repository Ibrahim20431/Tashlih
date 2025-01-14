import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

class AppBodyLayout extends StatelessWidget {
  const AppBodyLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radius26),
      ),
      child: ColoredBox(
        color: Colors.white,
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
