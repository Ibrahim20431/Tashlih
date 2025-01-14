import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/firebase/firebase_database_service.dart';
import '../../../../core/firebase/firebase_messaging_service.dart';
import '../../../../core/providers/app_life_cycle_provider.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/circular_loading_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/no_item_widget.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../controllers/notifiers/chats_notifier.dart';
import '../widgets/chat_widget.dart';

class ChatsView extends ConsumerStatefulWidget {
  const ChatsView({super.key});

  @override
  ConsumerState<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends ConsumerState<ChatsView>
    with WidgetsBindingObserver {
  late final FirebaseDatabaseService _database;

  late final int _thisUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _thisUserId = ref.read(userProvider)!.id;
    _database = const FirebaseDatabaseService();
    _database.updateActiveStatus(_thisUserId, UserPresence.online);
    _database.changeActiveStatusWhenConnectionChanged(_thisUserId);
    ref.read(chatsNotifierProvider.notifier).getChats();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _database.updateActiveStatus(_thisUserId, UserPresence.online);
      ref.read(firebaseMessagingProvider).cancelAll();
    } else if (state == AppLifecycleState.inactive) {
      _database.updateActiveStatus(_thisUserId, UserPresence.offline);
    }
    ref.read(appLifeCycleProvider.notifier).state = state;
    debugPrint(state.name);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'الدردشات',
      body: Padding(
        padding: const EdgeInsets.only(
          left: AppDimensions.screenPadding,
          top: AppDimensions.screenPadding,
          right: AppDimensions.screenPadding,
        ),
        child: Column(
          children: [
            SearchTextField(
              searchDuration: const Duration(milliseconds: 500),
              unFocusAfterSearch: false,
              onChangesEnd: ref.read(chatsNotifierProvider.notifier).search,
            ),
            Expanded(
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final chatsAsync = ref.watch(filteredChatsProvider);
                  return chatsAsync.when(
                    skipLoadingOnRefresh: false,
                    data: (chats) {
                      if (chats.isNotEmpty) {
                        return ListView.separated(
                          padding: const EdgeInsets.only(
                            top: AppDimensions.screenPadding,
                            bottom: AppDimensions.bottomBarWithFABPadding,
                          ),
                          itemBuilder: (_, index) => ChatWidget(chats[index]),
                          separatorBuilder: (_, __) => const CustomDivider(),
                          itemCount: chats.length,
                        );
                      } else {
                        return const NoItemWidget(
                          icon: Icons.chat_outlined,
                          title: 'لا توجد محادثات',
                        );
                      }
                    },
                    error: (error, _) => RetryWidget(
                      error: error,
                      onPressed: () {
                        ref.read(chatsNotifierProvider.notifier).reloadChats();
                      },
                    ),
                    loading: () => const CircularLoadingWidget(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
