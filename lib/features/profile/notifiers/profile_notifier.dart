import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/request_state.dart';
import '../../../../core/models/state_request_mixin.dart';
import '../../../core/constants/key_classes.dart';
import '../../../core/providers/shared_prefs_provider.dart';
import '../../../core/utils/helpers/exception_handler.dart';
import '../../auth/controllers/providers/user_provider.dart';
import '../../auth/data/models/id_name_model.dart';
import '../../product_details/data/models/product_model.dart';
import '../data/repositories/profile_repository.dart';

final class ProfileNotifier extends StateNotifier<RequestState<void>>
    with StateRequestMixin {
  ProfileNotifier(this._ref) : super(const InitState()) {
    _repo = _ref.read(profileRepoProvider);
    super.initializeRef(_ref);
  }

  final Ref _ref;
  late final ProfileRepository _repo;

  Future<void> updateProfile({
    required String name,
    required IdNameModel city,
    required String? image,
  }) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      final imageUrl = await _repo.updateProfile(
        name: name,
        city: city.id!,
        image: image,
      );
      final prefs = _ref.read(sharedPrefsProvider);
      final user = _ref
          .read(userProvider)!
          .copyWith(name: name, city: city, image: imageUrl);
      await prefs.setString(user.toJson(), StorageKeys.user);
      _ref.read(userProvider.notifier).state = user;
      _successState('تم تعديل البيانات بنجاح');
    } catch (e) {
      _errorState(e);
    }
  }

  void addProduct(ProductModel product) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.addProduct(product);
      _successState('تم إاضافة المنتج بنجاح');
    } catch (e) {
      _errorState(e);
    }
  }

  void updateProduct(ProductModel product) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.updateProduct(product);
      _successState('تم تعديل المنتج بنجاح');
    } catch (e) {
      _errorState(e);
    }
  }

  void deleteProduct(int id) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.deleteProduct(id);
      _successState('تم حذف المنتج بنجاح');
    } catch (e) {
      _errorState(e);
    }
  }

  void _loadingState() {
    super.loading();
    state = const LoadingState();
  }

  void _successState([String? message]) {
    super.success(message);
    state = const SuccessState();
  }

  void _errorState(Object error) {
    super.error(error, exceptionHandler(error));
    state = ErrorState(error);
  }
}

final profileNotifierProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, RequestState<void>>(
        ProfileNotifier.new);
