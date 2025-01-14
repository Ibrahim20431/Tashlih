import 'package:flutter/widgets.dart';

import '../constants/text_styles.dart';

class AlertDialogHeader extends StatelessWidget {
  const AlertDialogHeader({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.subtitleStyle = TextStyles.largeRegular,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final TextStyle? subtitleStyle;

  bool get _hasSubtitle => subtitle != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 80),
        const SizedBox(height: 16),
        Text(title, style: TextStyles.largeBold),
        if (_hasSubtitle) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: subtitleStyle,
            textAlign: TextAlign.center,
          ),
        ]
      ],
    );
  }
}
