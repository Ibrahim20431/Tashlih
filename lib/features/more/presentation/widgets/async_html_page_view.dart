import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/circular_loading_widget.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../../providers/html_page_provider.dart';

class AsyncHtmlPageView extends ConsumerWidget {
  const AsyncHtmlPageView(this.title, this.route, {super.key});

  final String title;
  final String route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageAsync = ref.watch(htmlPageProvider(route));
    return Scaffold(
      body: AppScaffold(
        title: title,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
          ),
          child: pageAsync.when(
            skipLoadingOnRefresh: false,
            data: (html) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.screenPadding,
              ),
              child: HtmlWidget(html),
            ),
            error: (error, _) => RetryWidget(
              error: error,
              onPressed: () => ref.invalidate(htmlPageProvider),
            ),
            loading: () => const CircularLoadingWidget(),
          ),
        ),
      ),
    );
  }
}
