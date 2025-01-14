import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    this.tileColor = primaryColor,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final Color tileColor;
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: tileColor,
      textColor: tileColor,
      titleTextStyle: TextStyles.mediumRegular,
      leading: icon,
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_left_rounded),
      onTap: onTap,
    );
  }
}
