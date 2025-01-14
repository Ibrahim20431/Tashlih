import 'package:flutter/material.dart';

import '../constants/text_styles.dart';

class NoItemWidget extends StatelessWidget {
  const NoItemWidget({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 120, color: Colors.grey),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(title, style: TextStyles.smallBold),
            )
          ],
        ),
      ),
    );
  }
}
