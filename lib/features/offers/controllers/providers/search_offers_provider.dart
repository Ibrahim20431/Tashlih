import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../../../order_offers/data/models/search_model.dart';

final searchOffersProvider = StateProvider((_) => SearchModel(''));
