import 'package:flutter/material.dart';

class FieldIcon extends StatelessWidget {
  const FieldIcon({
    super.key,
    required this.icon,
    this.iconColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor),
    );
  }
}
