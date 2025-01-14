import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers/exception_handler.dart';
import '../../../../core/widgets/circular_loading_widget.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/validator_dropdown.dart';
import '../../data/models/id_name_model.dart';

class FutureDropdown extends ConsumerStatefulWidget {
  const FutureDropdown({
    super.key,
    required this.itemsProvider,
    this.value,
    required this.icon,
    required this.hintText,
    this.validator,
    required this.onChanged,
    this.showValidator = true,
    this.exceedItems = const [],
    this.onTap,
    this.keepAlive = false,
  });

  final FutureProvider<List<IdNameModel>> itemsProvider;
  final IdNameModel? value;
  final IconData icon;
  final String hintText;
  final String? Function(IdNameModel?)? validator;
  final void Function(IdNameModel?) onChanged;
  final bool showValidator;
  final List<IdNameModel> exceedItems;
  final VoidCallback? onTap;
  final bool keepAlive;

  @override
  ConsumerState<FutureDropdown> createState() => _FutureDropdownState();
}

class _FutureDropdownState extends ConsumerState<FutureDropdown>
    with AutomaticKeepAliveClientMixin<FutureDropdown> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final itemsAsync = ref.watch(widget.itemsProvider);
    _listenProviderState();
    return itemsAsync.when(
      skipLoadingOnRefresh: false,
      data: (items) {
        if (widget.showValidator) {
          return ValidatorDropdown<IdNameModel?>(
            value: widget.value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.name),
                    ))
                .toList(),
            prefixIcon: widget.icon,
            labelText: widget.hintText,
            onChanged: widget.onChanged,
            validator: widget.validator,
            onTap: widget.onTap,
          );
        } else {
          return CustomDropdown<IdNameModel?>(
            value: widget.value,
            items: items
                .where((item) => !widget.exceedItems.contains(item))
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.name),
                    ))
                .toList(),
            icon: widget.icon,
            hintText: widget.hintText,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
          );
        }
      },
      error: (error, __) => ValidatorDropdown(
        prefixIcon: widget.icon,
        suffixIcon: const Icon(
          Icons.refresh_rounded,
          color: primaryColor,
        ),
        labelText: widget.hintText,
        validator: widget.validator,
        onTap: () => ref.invalidate(widget.itemsProvider),
      ),
      loading: () => ValidatorDropdown(
        prefixIcon: widget.icon,
        suffixIcon: const CircularLoadingWidget(size: 20),
        labelText: widget.hintText,
        validator: widget.validator,
      ),
    );
  }

  void _listenProviderState() {
    ref.listen(widget.itemsProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        context.showErrorBar(exceptionHandler(state.error));
      }
    });
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
