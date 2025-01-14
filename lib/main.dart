import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderContainer, UncontrolledProviderScope;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/firebase/firebase_messaging_service.dart';
import 'core/firebase/firebase_options.dart';
import 'core/providers/shared_prefs_provider.dart';
import 'app.dart';

/*
╔═══════════════════════════════════════════════════╗
║ Created by Mohammad Alamoudi on 03/2024           ║
║═══════════════════════════════════════════════════║
║ +967 7707 6 2202                                  ║
║ mhmd.al3moudi@gmail.com.                          ║
╚═══════════════════════════════════════════════════╝
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
  );

  container.read(firebaseMessagingProvider).initNotifications();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
