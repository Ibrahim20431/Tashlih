import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CircularLoadingWidget extends StatelessWidget {
  const CircularLoadingWidget({
    super.key,
    this.color = primaryColor,
    this.backgroundColor = Colors.white,
    this.size = 36,
    this.strokeWidth,
  });

  final Color color;
  final Color backgroundColor;
  final double size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                color: color,
                backgroundColor: backgroundColor,
                strokeWidth: strokeWidth ?? size / 8,
              ),
            )
          : CupertinoActivityIndicator(radius: size / 2, color: color),
    );
  }
}
