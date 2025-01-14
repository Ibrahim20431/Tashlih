import 'package:flutter/cupertino.dart' show CupertinoSwitch;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

class SettingSwitchTile extends StatelessWidget {
  const SettingSwitchTile({
    super.key,
    required this.value,
    required this.icon,
    required this.title,
    required this.onChanged,
  });

  final bool value;
  final IconData icon;
  final String title;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: TextStyles.mediumRegular.copyWith(color: primaryColor),
      ),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
      onTap: () => onChanged(!value),
    );
  }
}
