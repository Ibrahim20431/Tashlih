import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../providers/chats_with_new_messages_provider.dart';
import '../../providers/selected_page_provider.dart';

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(selectedPageProvider);
    final user = ref.read(userProvider);
    final isGuest = user == null;
    final isClient = isGuest || user.type == UserType.client;
    final iconList = <IconData>[
      if (isClient) ...[
        Icons.home,
        Icons.car_crash_rounded,
      ] else
        ...[
          Icons.shopping_bag_rounded,
          Icons.local_offer_rounded,
        ],
      Icons.chat_rounded,
      Icons.person,
    ];

    final textList = <String>[
      if (isClient) ...[
        AppTexts.stores,
        AppTexts.specializedCenters,
      ] else
        ...[
          'الطلبات',
          'العروض'
        ],
      AppTexts.messages,
      AppTexts.myAccount
    ];
    return AnimatedBottomNavigationBar.builder(
      height: 65,
      itemCount: 4,
      tabBuilder: (int index, bool isActive) {
        if (index != 2 || isGuest) {
          return _NavBarItem(
            isActive: isActive,
            icon: iconList[index],
            text: textList[index],
          );
        } else {
          return Center(
            child: Consumer(
              builder: (_, WidgetRef ref, __) {
                final count = ref.watch(chatsWithNewMessagesProvider);
                return Badge(
                  backgroundColor: primaryColor[300],
                  offset: const Offset(-5, 2),
                  largeSize: 20,
                  smallSize: 20,
                  textStyle: TextStyles.xSmallBold,
                  label: SizedBox(
                    height: 20,
                    width: 14,
                    child: Center(child: Text('$count')),
                  ),
                  isLabelVisible: count > 0,
                  child: _NavBarItem(
                    isActive: isActive,
                    icon: iconList[index],
                    text: textList[index],
                  ),
                );
              },
            ),
          );
        }
      },
      backgroundColor: Colors.white,
      activeIndex: activeIndex,
      splashColor: primaryColor,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.center,
      onTap: (index) {
        ref
            .read(selectedPageProvider.notifier)
            .state = index;
      },
      shadow: const BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 12,
        spreadRadius: 0.5,
        color: primaryColor,
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.isActive,
    required this.icon,
    required this.text,
  });

  final bool isActive;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? primaryColor : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppDimensions.padding8),
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        const SizedBox(height: 4),
        AutoSizeText(
          text,
          style: TextStyle(color: color),
          maxLines: 1,
          minFontSize: 10,
        ),
      ],
    );
  }
}
