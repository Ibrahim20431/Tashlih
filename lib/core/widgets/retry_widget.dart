import 'package:flutter/material.dart';

import '../utils/helpers/exception_handler.dart';

class RetryWidget extends StatelessWidget {
  final Object error;
  final void Function() onPressed;
  final Color? color;

  const RetryWidget({
    super.key,
    required this.error,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            exceptionHandler(error),
            style: TextStyle(color: color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              fixedSize: const Size.fromWidth(double.infinity),
            ),
            child: const Text('إعادة المحاولة'),
          )
        ],
      ),
    );
  }
}
