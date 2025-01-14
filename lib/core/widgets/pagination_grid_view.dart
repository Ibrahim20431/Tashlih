import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../extensions/context_extension.dart';
import '../models/pagination_model.dart';
import '../utils/helpers/exception_handler.dart';
import 'circular_loading_widget.dart';
import 'no_item_widget.dart';
import 'refresh_widget.dart';
import 'retry_widget.dart';

class PaginationGridView<T> extends StatefulWidget {
  const PaginationGridView({
    super.key,
    this.controller,
    this.startPage = 1,
    required this.gridDelegate,
    required this.getList,
    required this.itemBuilder,
    required this.onRefresh,
    required this.noItemWidget,
    this.padding = const EdgeInsets.all(AppDimensions.screenPadding),
    this.initialItems,
    this.isLastPage = false,
  });

  final PagingController<int, T>? controller;
  final int startPage;
  final SliverGridDelegate gridDelegate;
  final Future<PaginationModel<T>> Function(int) getList;
  final Widget Function(T, int) itemBuilder;
  final VoidCallback onRefresh;
  final EdgeInsetsGeometry? padding;
  final NoItemWidget noItemWidget;
  final bool isLastPage;
  final List<T>? initialItems;

  @override
  State<PaginationGridView<T>> createState() => _PaginationGridViewState<T>();
}

class _PaginationGridViewState<T> extends State<PaginationGridView<T>> {
  late final PagingController<int, T> controller;

  @override
  void initState() {
    if (widget.controller == null) {
      controller = PagingController<int, T>(firstPageKey: 1);
    } else {
      controller = widget.controller!;
    }
    if (widget.initialItems != null) {
      if (widget.isLastPage) {
        controller.appendLastPage(widget.initialItems!);
      } else {
        controller.appendPage(widget.initialItems!, widget.startPage);
      }
    }
    controller.addPageRequestListener(_fetchPage);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return RefreshWidget(
      onRefresh: _refresh,
      child: PagedGridView<int, T>(
        shrinkWrap: true,
        primary: true,
        pagingController: controller,
        padding: widget.padding,
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: (_, T t, int i) => widget.itemBuilder(t, i),
          noItemsFoundIndicatorBuilder: (_) => widget.noItemWidget,
          firstPageErrorIndicatorBuilder: (_) => RetryWidget(
            error: controller.error,
            onPressed: _refresh,
          ),
          firstPageProgressIndicatorBuilder: (_) => const CircularLoadingWidget(
            color: primaryColor,
          ),
          newPageErrorIndicatorBuilder: (_) => Center(
            child: GestureDetector(
              onTap: controller.retryLastFailedRequest,
              child: Text(
                '${controller.error}\nاضغط لإعادة المحاولة',
                style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          newPageProgressIndicatorBuilder: (_) => const CircularLoadingWidget(
            size: 20,
            color: primaryColor,
          ),
        ),
        gridDelegate: widget.gridDelegate,
      ),
    );
  }

  Future<void> _refresh() async {
    widget.onRefresh();
    controller.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final data = await widget.getList(pageKey);
      if (mounted) {
        if (data.isLastPage) {
          controller.appendLastPage(data.list);
        } else {
          controller.appendPage(data.list, data.currentPage + 1);
        }
      }
    } catch (error) {
      if (mounted) controller.error = exceptionHandler(error);
    }
  }
}
