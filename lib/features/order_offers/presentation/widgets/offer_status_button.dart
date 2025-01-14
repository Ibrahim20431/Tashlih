import 'package:flutter/material.dart' show Colors, ElevatedButton;
import 'package:flutter/widgets.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/text_styles.dart';

class OfferStatusButton extends StatelessWidget {
  const OfferStatusButton({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    this.onPressed,
    this.showDialog = true,
  });

  final Color color;
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool showDialog;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: Colors.transparent,
        disabledForegroundColor: color,
        side: BorderSide(color: color),
        fixedSize: const Size(double.maxFinite, 45),
        textStyle: TextStyles.mediumBold,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radius5),
          ),
        ),
      ),
      onPressed: onPressed != null
          ? () {
              if (showDialog) {
                context.showAlertDialog(
                  icon: icon,
                  title: label,
                  subtitle:
                      'هذه العملية غير قابلة للتراجع، تأكد من جميع المعلومات، هل ترغب بالمتابعة؟',
                  confirmLabel: label,
                  onConfirmPressed: (_) {
                    context.pop();
                    onPressed!();
                  },
                  cancelLabel: 'رجوع',
                );
              } else {
                onPressed!();
              }
            }
          : null,
      label: Text(label),
      icon: Icon(icon, size: 20),
    );
  }
}
