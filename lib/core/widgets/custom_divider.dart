import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.height = 32});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.grey[200], height: height);
  }
}
