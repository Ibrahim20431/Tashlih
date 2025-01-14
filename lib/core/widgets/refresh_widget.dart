import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../../core/constants/app_colors.dart' show primaryColor;

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return RefreshIndicator(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        color: primaryColor,
        onRefresh: onRefresh,
        child: child,
      );
    } else {
      return CustomScrollView(
        shrinkWrap: true,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverToBoxAdapter(child: child)
        ],
      );
    }
  }
}
