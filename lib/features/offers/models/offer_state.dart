import '../../../core/constants/key_enums.dart';

final class OfferState {
  const OfferState(this.priceWithVat, this.priceBeforeVat, this.status);

  final num priceWithVat;
  final num priceBeforeVat;
  final OrderOfferStatus status;

  OfferState copyWith({
    num? priceWithVat,
    num? priceBeforeVat,
    OrderOfferStatus? status,
  }) =>
      OfferState(
        priceWithVat ?? this.priceWithVat,
        priceBeforeVat ?? this.priceBeforeVat,
        status ?? this.status,
      );
}
