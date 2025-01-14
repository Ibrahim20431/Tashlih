import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../models/pagination_model.dart';
import '../utils/helpers/exception_handler.dart';
import 'circular_loading_widget.dart';
import 'no_item_widget.dart';
import 'refresh_widget.dart';
import 'retry_widget.dart';

class PaginationListView<T> extends StatefulWidget {
  const PaginationListView({
    super.key,
    this.controller,
    required this.getList,
    required this.itemBuilder,
    required this.onRefresh,
    required this.noItemWidget,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.loadingWidget,
    this.loadingColor,
  });

  final PagingController<int, T>? controller;
  final Future<PaginationModel<T>> Function(int) getList;
  final Widget Function(T, int) itemBuilder;
  final EdgeInsetsGeometry padding;
  final Widget? loadingWidget;
  final Color? loadingColor;
  final NoItemWidget noItemWidget;
  final void Function() onRefresh;

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  late final Widget loadingWidget;
  late final Color loadingColor;

  late final PagingController<int, T> controller;

  @override
  void initState() {
    if (widget.controller == null) {
      controller = PagingController<int, T>(firstPageKey: 1);
    } else {
      controller = widget.controller!;
    }
    loadingColor = widget.loadingColor ?? primaryColor;
    loadingWidget =
        widget.loadingWidget ?? CircularLoadingWidget(color: loadingColor);
    controller.addPageRequestListener(_fetchPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return RefreshWidget(
      onRefresh: _refresh,
      child: PagedListView<int, T>.separated(
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
          firstPageProgressIndicatorBuilder: (_) => loadingWidget,
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
          newPageProgressIndicatorBuilder: (_) => CircularLoadingWidget(
            size: 20,
            color: loadingColor,
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
      ),
    );
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

  Future<void> _refresh() async {
    widget.onRefresh();
    controller.refresh();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) controller.dispose();
  }
}
