import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../data/repositories/home_repository.dart';

final sliderImagesProvider = FutureProvider<List<String>>((ref) {
  final repo = ref.read(homeRepoProvider);
  return repo.getSliderImages();
});
