import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

import '../constants/app_dimensions.dart';
import '../extensions/context_extension.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.preventToolbarOptions,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.readOnly = false,
    this.fillColor = Colors.white,
    this.unFocusOnTapOut = true,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String?>? onChanged;
  final List<ContextMenuButtonType>? preventToolbarOptions;
  final TextAlign textAlign;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final Color fillColor;
  final bool unFocusOnTapOut;

  bool get _readOnly => onTap != null || readOnly;

  int get _maxLines => maxLines ?? minLines ?? 1;

  Widget? get _suffixIcon => suffixIcon != null
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [suffixIcon!],
        )
      : null;

  Widget? get _prefixIcon => prefixIcon != null ? Icon(prefixIcon) : null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      cursorColor: primaryColor,
      onTapOutside: unFocusOnTapOut ? (_) => context.unFocusScope() : null,
      textAlignVertical: TextAlignVertical.center,
      textAlign: textAlign,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: _readOnly,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: _maxLines,
      contextMenuBuilder: (context, editableTextState) {
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;
        if (preventToolbarOptions != null) {
          buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
            return preventToolbarOptions!.contains(buttonItem.type);
          });
        }
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        focusColor: primaryColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 20,
        ),
        hintText: hintText,
        labelText: labelText,
        errorMaxLines: 2,
        counterStyle: const TextStyle(fontSize: 0),
        counterText: '',
        prefixIcon: _prefixIcon,
        prefixIconColor: primaryColor,
        suffixIcon: _suffixIcon,
        suffixIconColor: primaryColor,
        border: _outLineBorder(Colors.grey),
        enabledBorder: _outLineBorder(Colors.grey),
        focusedBorder: _outLineBorder(primaryColor, 1.5),
        errorBorder: _outLineBorder(Colors.red),
      ),
    );
  }

  InputBorder _outLineBorder(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(AppDimensions.widgetRadius),
    );
  }
}
