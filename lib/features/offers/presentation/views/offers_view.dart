import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../../../order_offers/data/models/search_model.dart';
import '../../../order_offers/presentation/widgets/offers_future_list_view.dart';
import '../../../order_offers/presentation/widgets/order_offer_widget.dart';
import '../../controllers/providers/offers_provider.dart';
import '../../controllers/providers/search_offers_provider.dart';
import 'my_offer_view.dart';

class OffersView extends ConsumerStatefulWidget {
  const OffersView({super.key});

  @override
  ConsumerState<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends ConsumerState<OffersView> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _listenSearchState();
    return AppScaffold(
      title: 'قائمة العروض',
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          children: [
            SearchTextField(
              controller: _searchController,
              onChangesEnd: (search) {
                ref.read(searchOffersProvider.notifier).state =
                    SearchModel(search);
              },
            ),
            Expanded(
              child: OffersFutureListView(
                refreshProvider: searchOffersProvider,
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: AppDimensions.bottomBarWithFABPadding,
                ),
                getItems: () => ref.read(offersProvider.future),
                offerBuilder: (offer) => OrderOfferWidget(
                  title: offer.product.name,
                  offer: offer,
                  onTap: () => context.push(MyOfferView(offer)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listenSearchState() {
    ref.listen(searchOffersProvider, (_, search) {
      _searchController.text = search.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
