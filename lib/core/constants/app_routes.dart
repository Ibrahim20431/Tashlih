import 'package:flutter/widgets.dart' show BuildContext, Widget;

import '../../features/auth/presentation/views/login_view.dart';

abstract final class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    LoginView.routeName : (_) => const LoginView(),
    
  };
}
