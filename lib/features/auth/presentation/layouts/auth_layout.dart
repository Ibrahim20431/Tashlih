import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_classes.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../../../core/services/api_service.dart';
import '../../../main_layout/presentation/layouts/main_layout.dart';
import '../../controllers/notifiers/auth_notifier.dart';
import '../../controllers/providers/auth_type_provider.dart';
import '../../controllers/providers/user_provider.dart';
import '../views/login_view.dart';
import '../views/signup_view.dart';
import '../widgets/auth_scaffold_widget.dart';

class AuthLayout extends ConsumerStatefulWidget {
  const AuthLayout({super.key});

  @override
  ConsumerState<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends ConsumerState<AuthLayout>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      ref.read(authTypeProvider.notifier).state =
          AuthType.values.elementAt(controller.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenAuthState();
    final authType = ref.watch(authTypeProvider);
    final String title;
    final String subtitle;
    if (authType == AuthType.login) {
      title = 'تسجيل الدخول';
      subtitle = 'مرحباً بعودتك\nسجل الدخول للوصول إلى حسابك';
    } else {
      title = 'تسجيل جديد';
      subtitle = 'أهلاً بك\nيرجى تسجيل حساب جديد';
    }
    return AuthScaffold(
      title: title,
      subtitle: subtitle,
      bottom: TabBar(
        controller: controller,
        splashBorderRadius: BorderRadius.circular(20),
        tabs: const [
          Text('تسجيل الدخول'),
          Text('حساب جديد'),
        ],
      ),
      child: TabBarView(
        controller: controller,
        children: const [LoginView(), SignupView()],
      ),
    );
  }

  void _listenAuthState() {
    ref.listen(authNotifierProvider, (_, state) {
      if (state.hasData) {
        final data = state.requiredData;
        final page = data.page;
        final user = data.user;
        if (page != null) {
          context.push(page);
        } else if (user != null) {
          final token = data.token!;
          final prefs = ref.read(sharedPrefsProvider);
          prefs.setString(StorageKeys.user, user.toJson()).then((_) {
            prefs.setString(StorageKeys.token, token).then((_) {
              ApiService.token = token;
              ref.read(userProvider.notifier).state = user;
              prefs.setString(StorageKeys.user, user.toJson());
              prefs.setBool(StorageKeys.goToHome, true);
              context.pushAndPopAll(const MainLayout());
            });
          });
        } else {
          context.popAll();
        }
      } else if (state.hasError) {
        final page = state.data?.page;
        if (page != null) context.push(page);
      }
    });
  }
}
