import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AutoDisposeProvider, Ref;

import '../../../../core/constants/end_points.dart';
import '../../../../core/models/status_code_exception.dart';
import '../../../../core/services/api_service.dart';
import '../models/id_name_model.dart';
import '../models/register_validation_model.dart';
import '../models/trader_data_validation_model.dart';
import '../models/user_model.dart';

final class AuthRepository {
  AuthRepository(Ref ref) {
    _api = ref.read(apiProvider);
  }

  late final ApiService _api;

  final String _prefix = 'auth';

  Future<List<IdNameModel>> getCities() async {
    final response = await _api.get('cities/list');
    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data)
          .map(IdNameModel.fromMap)
          .toList();
    }
    throw response.message;
  }

  Future<List<IdNameModel>> getCarBrands() async {
    final response = await _api.get('categories/list');
    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data)
          .map(IdNameModel.fromMap)
          .toList();
    }
    throw response.message;
  }

  Future<({String token, UserModel user})> login(
    String mobile,
    String password,
    String fcmToken,
  ) async {
    final response = await _api.post(
      '$_prefix/login',
      body: {'mobile': mobile, 'password': password, 'fcm_token': fcmToken},
    );
    if (response.success) {
      return (
        token: response.data['token'] as String,
        user: UserModel.fromMap(response.data),
      );
    }
    throw StatusCodeException(
      statusCode: response.statusCode,
      message: response.message,
    );
  }

  Future<void> clientSignup(RegisterValidationModel user) async {
    final response = await _api.postWithFile(
      '$_prefix/register',
      body: user.toMap(),
      files: user.image != null ? {'image': user.image!} : null,
    );
    if (response.success) return;
    if (response.statusCode == 422) {
      throw RegisterValidationModel.fromMap(response.errors, response.message);
    }
    throw response.message;
  }

  Future<void> checkTraderData(RegisterValidationModel user) async {
    final response = await _api.post(
      '$_prefix/check-data',
      body: user.toMap(),
    );
    if (response.success) return;
    throw RegisterValidationModel.fromMap(response.errors, response.message);
  }

  Future<void> traderSignup(
    RegisterValidationModel user,
    TraderDataValidationModel trader,
  ) async {
    final response = await _api.postWithFile(
      '$_prefix/trader/register',
      body: {...user.toUserMap(), ...trader.toAuthMap()},
      files: {
        'store[image]': trader.image!,
        if (user.image != null) 'user[image]': user.image!,
      },
    );
    if (response.success) return;
    if (response.statusCode == 422) {
      throw TraderDataValidationModel.errorsFromMap(
        Map<String, List>.from(response.errors),
        response.message,
      );
    }
    throw response.message;
  }

  Future<({String token, UserModel user})> checkRegisterPinCode(
      String mobile, String code, String fcmToken) async {
    final response = await _api.post(
      '$_prefix/verification',
      body: {'mobile': mobile, 'code': code, 'fcm_token': fcmToken},
    );
    if (response.success) {
      return (
        token: response.data['token'] as String,
        user: UserModel.fromMap(response.data),
      );
    }
    throw response.message;
  }

  Future<void> checkUserMobile(String mobile) async {
    final response = await _api.post(
      'reset-password/send-otp',
      body: {'mobile': mobile},
    );
    if (response.success) return;
    throw response.message;
  }

  Future<void> checkResetPinCode(String mobile, String code) async {
    final response = await _api.post(
      'reset-password/check-otp',
      body: {'mobile': mobile, 'code': code},
    );
    if (response.success) return;
    throw response.message;
  }

  Future<void> resetPassword({
    required String mobile,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post(
      'reset-password/reset',
      body: {
        'mobile': mobile,
        'code': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    if (response.success) return;
    throw response.message;
  }

  Future<void> updateStore(TraderDataValidationModel store) async {
    final response = await _api.postWithFile(
      EndPoints.storeUpdate,
      body: store.toStoreMap(),
      files: store.image != null ? {'image': store.image!} : null,
    );
    if (response.success) return;
    if (response.statusCode == 422) {
      throw TraderDataValidationModel.errorsFromMap(
        Map<String, List>.from(response.errors),
        response.message,
      );
    }
    throw response.message;
  }

  Future<void> logout() async {
    final response = await _api.post(EndPoints.authLogout);
    if (response.success) return;
    throw response.message;
  }

  Future<void> deleteAccount() async {
    final response = await _api.post(EndPoints.authDeleteAccount);
    if (response.success) return;
    throw response.message;
  }
}

final authRepoProvider = AutoDisposeProvider(AuthRepository.new);
