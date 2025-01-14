import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/extensions/context_extension.dart';
import 'core/constants/app_locales.dart';
import 'core/constants/app_routes.dart';
import 'core/models/request_state.dart';
import 'core/providers/request_provider.dart';
import 'core/utils/navigator_key.dart';
import 'features/splash/views/splash_view.dart';
import 'config/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenApiRequestState(ref);
    return MaterialApp(
      title: 'تشليح',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: AppRoutes.routes,
      localizationsDelegates: AppLocales.delegates,
      supportedLocales: AppLocales.supportedLocales,
      locale: AppLocales.ar,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: const SplashView(),
    );
  }

  void _listenApiRequestState(WidgetRef ref) {
    ref.listen(requestProvider, (previous, state) {
      final context = navigatorKey.currentContext!;
      switch (state) {
        case LoadingState():
          if (!previous!.isLoading) context.showLoadingDialog();
        case SuccessState():
          if (previous!.isLoading) context.closeLoadingDialog();
          if (state.hasMessage) context.showSuccessBar(state.message!);
        case ErrorState():
          if (previous!.isLoading) context.closeLoadingDialog();
          if (state.hasMessage) context.showErrorBar(state.message!);
        case InitState():
          break;
      }
    });
  }
}
