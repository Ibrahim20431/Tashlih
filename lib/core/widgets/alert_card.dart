import 'package:flutter/material.dart';

import '../../core/extensions/context_extension.dart';
import 'alert_dialog_header.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    required this.onConfirmPressed,
    this.cancelLabel,
    this.onCancelPressed,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final void Function(BuildContext) onConfirmPressed;
  final String? cancelLabel;
  final VoidCallback? onCancelPressed;

  bool get _enableCancel => cancelLabel != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AlertDialogHeader(
          icon: icon,
          color: color,
          title: title,
          subtitle: subtitle,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            fixedSize: const Size(double.maxFinite, 45),
          ),
          onPressed: () => onConfirmPressed(context),
          child: Text(confirmLabel),
        ),
        if (_enableCancel)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(double.maxFinite, 45),
              ),
              onPressed: () {
                context.pop();
                if (onCancelPressed != null) onCancelPressed!();
              },
              child: Text(cancelLabel!),
            ),
          ),
      ],
    );
  }
}
