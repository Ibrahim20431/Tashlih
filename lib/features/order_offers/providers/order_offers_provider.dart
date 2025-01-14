import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../../core/constants/key_enums.dart';
import '../../my_orders/data/repositories/order_repository.dart';
import '../../offers/models/order_offer_model.dart';

final orderOffersProvider =
    FutureProvider.family<List<OrderOfferModel>, int>((ref, id) async {
  final repo = ref.read(orderRepoProvider);
  final offers = await repo.getOrderOffers(id);
  if (offers.length > 1) {
    // Check if offer is not waiting means there is an accepted offer and must
    // be pinned at top of the menu
    final offerStatus = ref.read(offers.first.offerNotifierProvider).status;
    if (offerStatus != OrderOfferStatus.waiting) {
      for (final offer in offers) {
        final status = ref.read(offer.offerNotifierProvider).status;
        if (status != OrderOfferStatus.rejected) {
          offers.remove(offer);
          offers.insert(0, offer);
          break;
        }
      }
    }
  }
  return offers;
});
