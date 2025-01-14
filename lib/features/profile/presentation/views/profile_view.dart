import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/network_image_widget.dart';
import '../../../auth/controllers/notifiers/auth_notifier.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../auth/presentation/layouts/auth_layout.dart';
import '../../../edit_profile/presentation/views/edit_profile_view.dart';
import '../../../edit_store/presentation/views/edit_store_view.dart';
import '../../../more/presentation/views/more_view.dart';
import '../../../more/presentation/widgets/async_html_page_view.dart';
import '../../../my_orders/presentation/views/my_orders_view.dart';
import '../../../my_orders/providers/client_orders_provider.dart';
import '../../../my_store/views/my_store_view.dart';
import '../../../policy/policy_view.dart';
import '../../../manage_product/presentation/views/add_product_view.dart';
import '../../notifiers/notification_notifier.dart';
import '../widgets/setting_switch_tile.dart';
import '../widgets/setting_tile.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    _listenAuthState(context, ref);
    final List<Widget> tiles = [
      if (user != null) ...[
        SettingTile(
          icon: Image.asset(PngIcons.editProfile, width: 24),
          title: 'تعديل بياناتي',
          onTap: () => context.push(const EditProfileView()),
        ),
        if (user.type == UserType.client)
          SettingTile(
            icon: const Icon(Icons.fact_check),
            title: 'طلباتي',
            onTap: () {
              ref.invalidate(clientOrdersProvider);
              context.push(const MyOrdersView());
            },
          )
        else ...[
          SettingTile(
            icon: const Icon(Icons.store_rounded),
            title: 'متجري',
            onTap: () => context.push(const MyStoreView()),
          ),
          SettingTile(
            icon: const Icon(Icons.edit_rounded),
            title: 'تعديل متجري',
            onTap: () => context.push(const EditStoreView()),
          ),
          SettingTile(
            icon: const Icon(Icons.add_rounded),
            title: 'إضافة منتج',
            onTap: () => context.push(const AddProductView()),
          ),
        ],
        SettingSwitchTile(
          value: user.notificationStatus,
          icon: Icons.notifications_active,
          title: 'الإشعارات',
          onChanged: (_) {
            ref.read(notificationNotifierProvider.notifier).change();
          },
        )
      ],
      SettingTile(
        icon: const Icon(Icons.info_rounded),
        title: 'من نحن',
        onTap: () => context.push(const AsyncHtmlPageView('من نحن', 'about')),
      ),
      SettingTile(
        icon: const Icon(Icons.privacy_tip_rounded),
        title: 'سياسة التطبيق',
        onTap: () => context.push(const PolicyView()),
      ),
      SettingTile(
        icon: const Icon(Icons.more_rounded),
        title: 'المزيد',
        onTap: () => context.push(const MoreView()),
      ),
      if (user != null) ...[
        SettingTile(
          tileColor: AppColors.red,
          icon: const Icon(Icons.logout_rounded),
          title: 'تسجيل الخروج',
          onTap: () {
            context.showAlertDialog(
              icon: Icons.logout_rounded,
              color: AppColors.red,
              title: 'تسجيل الخروج',
              subtitle: 'سيتم تسجيل خروجك، يمكنك العوده لاحقاً',
              confirmLabel: 'تسجيل الخروج',
              onConfirmPressed: (context) {
                context.pop();
                ref.read(authNotifierProvider.notifier).requestLogout();
              },
              cancelLabel: 'الغاء',
            );
          },
        ),
        SettingTile(
          tileColor: AppColors.red,
          icon: const Icon(Icons.person_remove_alt_1_rounded),
          title: 'حذف حسابي',
          onTap: () {
            context.showAlertDialog(
              icon: Icons.person_remove_alt_1_rounded,
              color: AppColors.red,
              title: 'حذف الحساب',
              subtitle:
                  'عند حذف الحساب وانتهاء مهلة العودة (راجع سياسة التطبيق) لن تتمكن من الوصول مرة أخرى إلى معلوماتك أو العروض المقدمة أو المحادثات التي تمت',
              confirmLabel: 'حذف حسابي',
              onConfirmPressed: (context) {
                context.pop();
                context.showAlertDialog(
                  icon: Icons.person_remove_alt_1_rounded,
                  color: AppColors.red,
                  title: 'حذف الحساب',
                  subtitle: 'حذف الحساب بشكل نهائي؟',
                  confirmLabel: 'حذف حسابي',
                  onConfirmPressed: (context) {
                    context.pop();
                    ref.read(authNotifierProvider.notifier).deleteAccount();
                  },
                  cancelLabel: 'الغاء',
                );
              },
              cancelLabel: 'الغاء',
            );
          },
        ),
      ]
    ];

    return AppScaffold(
      title: AppTexts.myAccount,
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Material(
          child: Column(
            children: [
              if (user != null)
                Column(
                  children: [
                    NetworkImageWidget(user.image, size: 100),
                    const SizedBox(height: 8),
                    Text(user.name, style: TextStyles.largeMedium),
                  ],
                )
              else ...[
                const Icon(Icons.login_rounded, size: 100, color: primaryColor),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                    onPressed: () => context.pushReplacement(
                      const AuthLayout(),
                    ),
                    child: const Text('تسجيل الدخول'),
                  ),
                )
              ],
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.bottomBarWithFABPadding,
                  ),
                  itemBuilder: (_, int index) => tiles[index],
                  separatorBuilder: (_, __) => const CustomDivider(height: 0),
                  itemCount: tiles.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _listenAuthState(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (_, state) async {
      // User Logout
      if (state.hasData) {
        final prefs = ref.read(sharedPrefsProvider);
        prefs.clear().then((_) {
          ApiService.token = null;
          ref.read(userProvider.notifier).state = null;
          context.pushAndPopAll(const AuthLayout());
        });
      }
    });
  }
}
