import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class ValidatorDropdown<T> extends StatefulWidget {
  ValidatorDropdown({
    super.key,
    this.value,
    this.items,
    this.onChanged,
    IconData? prefixIcon,
    this.validator,
    this.onTap,
    this.labelText,
    Widget? suffixIcon,
    this.keepAlive = false,
  }) {
    sufIcon = suffixIcon ??
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: primaryColor,
        );
    icon = prefixIcon != null ? Icon(prefixIcon) : null;
  }

  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  late final Widget? icon;
  final String? Function(T?)? validator;
  final void Function()? onTap;
  late final Widget? sufIcon;
  final String? labelText;
  final bool keepAlive;

  @override
  State<ValidatorDropdown<T>> createState() => _ValidatorDropdownState<T>();
}

class _ValidatorDropdownState<T> extends State<ValidatorDropdown<T>> with AutomaticKeepAliveClientMixin<ValidatorDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: DropdownButtonFormField<T>(
        value: widget.value,
        items: widget.items,
        onChanged: widget.onChanged,
        validator: widget.validator,
        icon: widget.sufIcon,
        dropdownColor: Colors.white,
        padding: const EdgeInsets.all(0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(14, 14, 22, 14),
          errorMaxLines: 2,
          labelText: widget.labelText != null ? '  ${widget.labelText}' : null,
          prefixIcon: widget.icon,
          prefixIconColor: primaryColor,
          border: _outLineBorder(Colors.grey),
          enabledBorder: _outLineBorder(Colors.grey),
          focusedBorder: _outLineBorder(Colors.grey),
          errorBorder: _outLineBorder(Colors.red),
        ),
      ),
    );
  }

  InputBorder _outLineBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(AppDimensions.widgetRadius),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
