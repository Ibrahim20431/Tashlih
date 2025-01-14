import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extension.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/text_styles.dart';

class SearchTextField extends ConsumerStatefulWidget {
  const SearchTextField({
    super.key,
    this.controller,
    this.unFocusAfterSearch = true,
    this.searchDuration = const Duration(seconds: 1),
    required this.onChangesEnd,
  });

  final Duration searchDuration;
  final bool unFocusAfterSearch;
  final TextEditingController? controller;
  final void Function(String) onChangesEnd;

  @override
  ConsumerState<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends ConsumerState<SearchTextField> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.height41,
      child: TextField(
        controller: widget.controller,
        onChanged: (val) {
          if (timer != null && timer!.isActive) timer!.cancel();
          timer = Timer(widget.searchDuration, () {
            if (widget.unFocusAfterSearch) context.unFocusScope();
            widget.onChangesEnd(val);
          });
        },
        onTapOutside: (_) => context.unFocusScope(),
        cursorHeight: 16,
        style: TextStyles.smallBold.copyWith(
          color: primaryColor,
        ),
        decoration: InputDecoration(
          enabledBorder: _inputBorder(),
          border: _inputBorder(),
          focusedBorder: _inputBorder(),
          hintText: 'بحث...',
          hintStyle: TextStyles.smallBold.copyWith(
            color: primaryColor,
          ),
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(Icons.search, color: primaryColor),
        ),
      ),
    );
  }

  InputBorder _inputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(AppDimensions.radius5),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
