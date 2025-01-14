import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../widgets/alert_card.dart';
import '../widgets/circular_loading_widget.dart';
import '../widgets/custom_bottom_sheet.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;

  double get navigationBarHeight => MediaQuery.of(this).viewPadding.bottom;

  Future push(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  // void push(String routeName) {
  //   Navigator.of(this).pushNamed(routeName);
  // }

  Future pushReplacement(Widget page) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  // void pushReplacement(String routeName) {
  //   Navigator.of(this).pushReplacementNamed(routeName);
  // }

  void pop() => Navigator.pop(this);

  void popAll() => Navigator.of(this).popUntil((route) => route.isFirst);

  void pushAndPopAll(Widget page) {
    popAll();
    pushReplacement(page);
  }

  void showSuccessBar(String message, {SnackBarAction? action}) {
    showSnackBar(
      message,
      color: primaryColor,
      icon: Icons.check_circle_rounded,
      action: action,
    );
  }

  void showErrorBar(String message, {SnackBarAction? action}) {
    showSnackBar(
      message,
      color: Colors.red,
      icon: Icons.info_rounded,
      action: action,
    );
  }

  void showSnackBar(
    String message, {
    required Color color,
    IconData? icon,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
            ),
            if (action == null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white)
            ]
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }

  void unFocusScope() => FocusScope.of(this).unfocus();

  static bool _isLoading = false;

  void showLoadingDialog() {
    if (_isLoading) return;
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CircularLoadingWidget(),
          ),
        ),
      ),
    );
    _isLoading = true;
  }

  void closeLoadingDialog() {
    if (_isLoading) {
      Navigator.of(this).pop();
      _isLoading = false;
    }
  }

  Future showAlertDialog({
    required IconData icon,
    Color color = primaryColor,
    required String title,
    required String subtitle,
    required String confirmLabel,
    required void Function(BuildContext) onConfirmPressed,
    VoidCallback? onCancelPressed,
    String? cancelLabel,
    bool canPop = true,
  }) {
    return showCustomDialog(
      AlertCard(
        icon: icon,
        color: color,
        title: title,
        subtitle: subtitle,
        confirmLabel: confirmLabel,
        onConfirmPressed: onConfirmPressed,
        cancelLabel: cancelLabel,
        onCancelPressed: onCancelPressed,
      ),
      canPop: canPop,
    );
  }

  Future showCustomDialog(Widget dialog, {bool canPop = true}) {
    return showGeneralDialog(
      context: this,
      barrierDismissible: canPop,
      barrierLabel: 'نافذة تنبية',
      pageBuilder: (context, animation, secondaryAnimation) => ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
          reverseCurve: Curves.easeIn,
        ),
        child: PopScope(
          canPop: canPop,
          child: Dialog(
            alignment: Alignment.center,
            insetAnimationCurve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.padding32),
              child: dialog,
            ),
          ),
        ),
      ),
    );
  }

  Future<T?> showBottomSheet<T>({
    required String title,
    required Widget child,
    required String okLabel,
    required void Function() onOkPressed,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: primaryColor[800],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius26),
        ),
      ),
      constraints: BoxConstraints(maxHeight: height * 0.9),
      builder: (_) => CustomBottomSheet(
        title: title,
        okLabel: okLabel,
        onOkPressed: onOkPressed,
        child: child,
      ),
    );
  }
}
