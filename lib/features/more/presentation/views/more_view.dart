import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/circular_loading_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/network_image_widget.dart';
import '../../../../core/widgets/no_item_widget.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../../../profile/presentation/widgets/setting_tile.dart';
import '../../providers/more_pages_provider.dart';
import '../widgets/html_page_view.dart';

class MoreView extends ConsumerWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesAsync = ref.watch(morePagesProvider);
    return Scaffold(
      body: AppScaffold(
        title: 'المزيد',
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
          ),
          child: pagesAsync.when(
            skipLoadingOnRefresh: false,
            data: (pages) {
              if (pages.isNotEmpty) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.screenPadding,
                  ),
                  itemBuilder: (_, int index) {
                    final page = pages[index];
                    return SettingTile(
                      icon: page.hasImage
                          ? NetworkImageWidget(
                              page.image!,
                              size: 24,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            )
                          : const Icon(Icons.info_rounded),
                      title: page.title,
                      onTap: () => context.push(
                        HtmlPageView(page.title, page.html),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const CustomDivider(height: 0),
                  itemCount: pages.length,
                );
              } else {
                return const NoItemWidget(
                  icon: Icons.more_horiz_sharp,
                  title: 'لا توجد صفحات أخرى',
                );
              }
            },
            error: (error, _) => RetryWidget(
              error: error,
              onPressed: () => ref.invalidate(morePagesProvider),
            ),
            loading: () => const CircularLoadingWidget(),
          ),
        ),
      ),
    );
  }
}
