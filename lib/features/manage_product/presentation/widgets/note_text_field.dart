import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import '../../../../core/widgets/custom_text_field.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField(this.controller, {super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      prefixIcon: Icons.note_alt_outlined,
      labelText: 'ملاحظات',
      minLines: 3,
      maxLines: 5,
    );
  }
}
