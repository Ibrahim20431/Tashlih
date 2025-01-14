import 'package:flutter/widgets.dart' show Widget;

import 'user_model.dart';

final class AuthState {
  const AuthState({
    this.token,
    this.user,
    this.page,
  });

  final String? token;
  final UserModel? user;
  final Widget? page;
}
