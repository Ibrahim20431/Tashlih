import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/firebase/firebase_messaging_service.dart';
import '../../../../core/models/request_state.dart';
import '../../../../core/models/state_request_mixin.dart';
import '../../../../core/models/status_code_exception.dart';
import '../../../../core/utils/helpers/exception_handler.dart';
import '../../data/models/auth_state.dart';
import '../../data/models/register_validation_model.dart';
import '../../data/models/trader_data_validation_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../presentation/views/pin_code_view.dart';
import '../../presentation/views/reset_password_view.dart';
import '../../presentation/views/trader_data_view.dart';

final class AuthNotifier extends StateNotifier<RequestState<AuthState>>
    with StateRequestMixin {
  AuthNotifier(this._ref) : super(const InitState()) {
    _repo = _ref.read(authRepoProvider);
    super.initializeRef(_ref);
  }

  final Ref _ref;
  late final AuthRepository _repo;
  late RegisterValidationModel traderUserRegister;

  late String userMobile;
  late String pinCode;

  Future<void> login(String mobile, String password) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      if (FirebaseMessagingService.fcmToken == null) {
        await _ref.read(firebaseMessagingProvider).initFCMToken();
      }
      final data = await _repo.login(
        mobile,
        password,
        FirebaseMessagingService.fcmToken!,
      );
      _successState(token: data.token, user: data.user);
    } on StatusCodeException catch (e) {
      if (e.statusCode == 409) {
        userMobile = mobile;
        _errorState(
          error: e.message,
          pushPage: PinCodeView(onValidated: checkRegisterPinCode),
        );
      } else {
        _errorState(error: e.message);
      }
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> clientSignup(RegisterValidationModel userRegister) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.clientSignup(userRegister);
      userMobile = userRegister.mobile!;
      _successState(pushPage: PinCodeView(onValidated: checkRegisterPinCode));
    } on RegisterValidationModel catch (e) {
      _errorState(error: e, message: e.message);
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> checkTraderData(RegisterValidationModel userRegister) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.checkTraderData(userRegister);
      traderUserRegister = userRegister;
      _successState(pushPage: const TraderDataView());
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> traderSignup(TraderDataValidationModel traderRegister) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.traderSignup(traderUserRegister, traderRegister);
      userMobile = traderUserRegister.mobile!;
      _successState(pushPage: PinCodeView(onValidated: checkRegisterPinCode));
    } on TraderDataValidationModel catch (e) {
      _errorState(error: e, message: e.message);
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> checkRegisterPinCode(String code) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      final data = await _repo.checkRegisterPinCode(
        userMobile,
        code,
        FirebaseMessagingService.fcmToken!,
      );
      _successState(token: data.token, user: data.user);
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> checkUserMobile(String mobile) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.checkUserMobile(mobile);
      userMobile = mobile;
      _successState(pushPage: PinCodeView(onValidated: checkResetPinCode));
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> checkResetPinCode(String code) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.checkResetPinCode(userMobile, code);
      pinCode = code;
      _successState(pushPage: const ResetPasswordView());
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> resetPassword(
    String password,
    String passwordConfirmation,
  ) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.resetPassword(
        mobile: userMobile,
        code: pinCode,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      _successState(
        message: 'تم إعادة تعيين كلمة المرور، سجل الدخول بكلمة المرور الجديدة',
      );
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> updateStore(TraderDataValidationModel store) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.updateStore(store);
      _successState(message: 'تم تعديل البيانات بنجاح');
    } on TraderDataValidationModel catch (e) {
      _errorState(error: e, message: e.message);
    } catch (e) {
      _errorState(error: e);
    }
  }

  Future<void> requestLogout() async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.logout();
      logout('تم تسجيل الخروج بنجاح');
    } catch (e) {
      _errorState(error: e);
    }
  }

  void logout([String? message]) => _successState(message: message);

  Future<void> deleteAccount() async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.deleteAccount();
      _successState(message: 'تم حذف الحساب بنجاح');
    } catch (e) {
      _errorState(error: e);
    }
  }

  void _loadingState() {
    super.loading();
    state = const LoadingState();
  }

  void _successState({
    String? token,
    UserModel? user,
    Widget? pushPage,
    String? message,
  }) {
    super.success(message);
    state = SuccessState(
      data: AuthState(
        token: token,
        user: user,
        page: pushPage,
      ),
    );
  }

  void _errorState({required Object error, String? message, Widget? pushPage}) {
    super.error(error, message ?? exceptionHandler(error));
    state = ErrorState(
      error,
      data: AuthState(page: pushPage),
    );
  }
}

final authNotifierProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, RequestState<AuthState>>(
        AuthNotifier.new);
