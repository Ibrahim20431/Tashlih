import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import '../../../core/constants/key_classes.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/firebase/firebase_keys.dart';
import '../../../core/providers/shared_prefs_provider.dart';
import '../../../core/services/api_service.dart';
import '../../../core/widgets/circular_loading_widget.dart';
import '../../auth/presentation/layouts/auth_layout.dart';
import '../../main_layout/presentation/layouts/main_layout.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularLoadingWidget(),
      ),
    );
  }

  void _initialize() async {
    final docPath = (await getApplicationDocumentsDirectory()).path;
    FirebaseCollections.localeAudiosPath =
        '$docPath/${FirebaseCollections.audios}';
    FirebaseCollections.localeImagesPath =
        '$docPath/${FirebaseCollections.images}';

    _initToken();
    
    Future.delayed(Duration.zero, () {
      final prefs = ref.read(sharedPrefsProvider);
      final goToHome = prefs.getBool(StorageKeys.goToHome) ?? false;
      if (goToHome) {
        context.pushReplacement(const MainLayout());
      } else {
        context.pushReplacement(const AuthLayout());
      }
    });
  }

  void _initToken() {
    final prefs = ref.read(sharedPrefsProvider);
    final token = prefs.getString(StorageKeys.token);
    if (token != null) ApiService.token = token;
  }
}
