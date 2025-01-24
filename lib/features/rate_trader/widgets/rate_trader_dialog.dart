import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';
import '../notifiers/rate_trader_notifier.dart';

class RateTraderDialog extends ConsumerWidget {
  const RateTraderDialog({
    super.key,
    this.initialRate = 3,
    required this.traderId,
    required this.traderName,
  });

  final double initialRate;
  final int traderId;
  final String traderName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double rate = initialRate;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.stars_rounded,
          color: Colors.amber,
          size: 80,
        ),
        const SizedBox(height: 8),
        const Text(
          'تقييم',
          style: TextStyles.largeBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          traderName,
          style: TextStyles.xLargeBold.copyWith(color: primaryColor),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: RatingBar(
            initialRating: double.infinity,
            minRating: 1,
            glow: false,
            itemSize: 30.0,     //
            ratingWidget: RatingWidget(
              full: const Icon(Icons.star, color: Colors.amber),
              half: const Icon(Icons.star_half_outlined),
              empty: const Icon(Icons.star_outline, color: Colors.grey),
            ),
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (val) => rate = val,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.maxFinite, 45),
          ),
          onPressed: () {
            context.pop();
            ref.read(rateTraderNotifierProvider.notifier).rate(traderId, rate);
          },
          child: const Text('تقييم'),
        ),
      ],
    );
  }
}
