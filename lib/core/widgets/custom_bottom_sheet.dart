import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.child,
    required this.okLabel,
    required this.onOkPressed,
  });

  final String title;
  final Widget child;
  final String okLabel;
  final void Function() onOkPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.screenPadding,
        AppDimensions.screenPadding,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: primaryColor[300],
              borderRadius: BorderRadius.circular(40),
            ),
            child: SizedBox(height: 3, width: context.width * 0.1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48),
              Text(title),
              IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.close_rounded),
              )
            ],
          ),
          const Divider(height: 0),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: child,
            ),
          ),
          ElevatedButton(onPressed: onOkPressed, child: Text(okLabel))
        ],
      ),
    );
  }
}
