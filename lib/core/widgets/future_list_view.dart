import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'circular_loading_widget.dart';
import 'no_item_widget.dart';
import 'refresh_widget.dart';
import 'retry_widget.dart';

class FutureListView<T, S> extends ConsumerStatefulWidget {
  const FutureListView({
    super.key,
    this.onRefresh,
    this.refreshProvider,
    required this.getItems,
    required this.itemBuilder,
    required this.noItemWidget,
    this.padding,
  });

  final VoidCallback? onRefresh;
  final StateProvider<S>? refreshProvider;
  final Future<List<T>> Function() getItems;
  final Widget Function(T, int) itemBuilder;
  final NoItemWidget noItemWidget;
  final EdgeInsetsGeometry? padding;

  @override
  ConsumerState<FutureListView<T, S>> createState() =>
      _FutureListViewState<T, S>();
}

class _FutureListViewState<T, S> extends ConsumerState<FutureListView<T, S>> {
  late Future<List<T>> getItems;

  @override
  void initState() {
    super.initState();
    getItems = widget.getItems();
  }

  @override
  Widget build(BuildContext context) {
    _listenRefreshState();
    return FutureBuilder(
      future: getItems,
      builder: (_, AsyncSnapshot<List<T>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularLoadingWidget();
        } else if (snapshot.hasData) {
          final items = snapshot.requireData;
          if (items.isNotEmpty) {
            return RefreshWidget(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: widget.padding,
                itemBuilder: (_, int index) =>
                    widget.itemBuilder(items[index], index),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: items.length,
              ),
            );
          } else {
            return widget.noItemWidget;
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: RetryWidget(
              error: snapshot.error!,
              onPressed: _refresh,
            ),
          );
        }
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {
      if (widget.onRefresh != null) widget.onRefresh!();
      getItems = widget.getItems();
    });
  }

  void _listenRefreshState() {
    if (widget.refreshProvider != null) {
      ref.listen(widget.refreshProvider!, (_, __) => _refresh());
    }
  }
}
