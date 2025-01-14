import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/text_styles.dart';
import 'app_body_layout.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.centerTitle = true,
    this.leading,
    this.leadingWidth,
    this.actions,
  });

  final bool centerTitle;
  final String title;
  final Widget body;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: primaryColor[400]!,
      child: Column(
        children: [
          AppBar(
            centerTitle: centerTitle,
            leading: leading,
            leadingWidth: leadingWidth,
            title: Text(title, style: TextStyles.heading3Bold),
            actions: actions,
          ),
          Expanded(child: AppBodyLayout(child: body))
        ],
      ),
    );
  }
}
