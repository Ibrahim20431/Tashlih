import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class SendMessageWidget extends StatelessWidget {
  const SendMessageWidget({
    super.key,
    required this.onTap,
    this.icon = Icons.send_rounded,
  });

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(icon, key: Key('${icon.hashCode}')),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
        ),
      ),
    );
  }
}
