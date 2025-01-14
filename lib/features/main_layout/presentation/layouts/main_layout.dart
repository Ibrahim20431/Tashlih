import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/providers/response_provider.dart';
import '../../../auth/controllers/notifiers/auth_notifier.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../chats/presentation/views/chats_view.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../offers/presentation/views/offers_view.dart';
import '../../../orders/presentation/views/orders_view.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../specialized_centers/views/specialized_centers_view.dart';
import '../../providers/selected_page_provider.dart';
import '../views/must_login_view.dart';
import '../widgets/fab.dart';
import '../widgets/nav_bar.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(selectedPageProvider);
    final user = ref.read(userProvider);
    _listenApiResponseState(context, ref);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: IndexedStack(
        index: selectedPage,
        children: [
          if (user == null || user.type == UserType.client) ...[
            const HomeView(),
            const SpecializedCentersView()
          ] else ...[
            const OrdersView(),
            const OffersView(),
          ],
          if (user != null)
            const ChatsView()
          else
            const MustLoginView(AppTexts.messages),
          const ProfileView(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FAB(),
      bottomNavigationBar: const NavBar(),
    );
  }

  void _listenApiResponseState(BuildContext context, WidgetRef ref) {
    ref.listen(responseProvider, (_, state) {
      if (state.message == 'Unauthenticated.') {
        context.showErrorBar('انتهت الجلسة، يرجى تسجيل الدخول');
        ref.read(authNotifierProvider.notifier).logout();
      }
    });
  }
}
