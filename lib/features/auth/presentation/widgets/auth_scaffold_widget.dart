import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_body_layout.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.bottom,
    required this.child,
  });

  final String title;
  final String subtitle;
  final PreferredSizeWidget? bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor[400],
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: primaryColor[400],
        foregroundColor: Colors.white,
        leadingWidth: 30,
        title: Text(
          title,
          style: TextStyles.mediumBold.copyWith(
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                subtitle,
                style: TextStyles.xLargeBold.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: AppDimensions.screenPadding,
                right: AppDimensions.screenPadding,
              ),
              child: bottom!,
            ),
          const SizedBox(height: 16),
          Expanded(child: AppBodyLayout(child: child)),
        ],
      ),
    );
  }
}
