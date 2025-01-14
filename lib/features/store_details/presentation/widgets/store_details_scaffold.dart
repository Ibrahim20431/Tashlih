import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/models/pagination_params_model.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/utils/helpers/lunch_dial_tel.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/network_image_widget.dart';
import '../../../../core/widgets/no_item_widget.dart';
import '../../../../core/widgets/pagination_list_view.dart';
import '../../../product_details/data/models/product_model.dart';
import '../../../profile/notifiers/profile_notifier.dart';
import '../../data/models/store_model.dart';
import '../../providers/products_provider.dart';
import 'start_chat_button.dart';
import 'store_contact_widget.dart';

class StoreDetailsScaffold extends ConsumerStatefulWidget {
  const StoreDetailsScaffold(
    this.store, {
    super.key,
    required this.itemBuilder,
    required this.hasChatButton,
  });

  final StoreModel store;
  final Widget Function(ProductModel) itemBuilder;
  final bool hasChatButton;

  @override
  ConsumerState<StoreDetailsScaffold> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends ConsumerState<StoreDetailsScaffold> {
  final controller = PagingController<int, ProductModel>(firstPageKey: 1);

  late final StoreModel store;

  @override
  void initState() {
    super.initState();
    store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    _listenProfileState();
    late PaginationParamsModel params;
    return Scaffold(
      body: AppScaffold(
        title: store.name,
        body: Padding(
          padding: const EdgeInsets.only(
            top: AppDimensions.screenPadding,
            left: AppDimensions.screenPadding,
            right: AppDimensions.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (store.isSpecialist)
                Column(
                  children: [
                    const Text('متجر متخصص'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: store.specialties!
                          .map((company) => InfoCard(info: company))
                          .toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  NetworkImageWidget(
                    store.image,
                    size: widget.hasChatButton ? 130 : 100,
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StoreContactWidget(
                          icon: Icons.location_on_outlined,
                          label: store.city,
                        ),
                        const SizedBox(height: 16),
                        StoreContactWidget(
                          icon: Icons.call_outlined,
                          label: store.mobile,
                          style: TextStyles.largeMedium.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          onTap: () => lunchDialTel(store.mobile),
                        ),
                        if (widget.hasChatButton) ...[
                          const SizedBox(height: 16),
                          StartChatButton(
                            store.toChat(),
                            fixedSize: const Size(double.maxFinite, 40),
                          )
                        ]
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Text('التشاليح', style: TextStyles.largeBold),
              Expanded(
                child: PaginationListView(
                  controller: controller,
                  getList: (page) {
                    params = PaginationParamsModel(page, store.id);
                    return ref.read(productsProvider(params).future);
                  },
                  itemBuilder: (product, _) => widget.itemBuilder(product),
                  noItemWidget: const NoItemWidget(
                    icon: Icons.no_encryption_outlined,
                    title: 'لا توجد منتجات',
                  ),
                  onRefresh: () => ref.invalidate(productsProvider),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _listenProfileState() {
    ref.listen(profileNotifierProvider, (_, state) {
      if (state.hasData) {
        ref.invalidate(productsProvider);
        controller.refresh();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
