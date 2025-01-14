import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart' show Widget, debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extension.dart';
import '../../features/chats/data/models/chat_model.dart';
import '../../features/chats/presentation/views/chat_view.dart';
import '../../features/main_layout/providers/selected_page_provider.dart';
import '../constants/globals.dart';
import '../utils/navigator_key.dart';
import 'firebase_keys.dart';

final firebaseMessagingProvider = Provider(FirebaseMessagingService.new);

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  _printMessageData(message);
}

final class FirebaseMessagingService {
  FirebaseMessagingService(this._ref);

  final Ref _ref;

  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  static String? fcmToken;

  Future<void> initNotifications() async {
    await initFCMToken();
    _initPushNotifications();
    _initLocalNotifications();
  }

  Future<void> initFCMToken() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }
      if (apnsToken != null) fcmToken = await _firebaseMessaging.getToken();
    } else {
      fcmToken = await _firebaseMessaging.getToken();
    }
    debugPrint('Firebase FCM Token ===> $fcmToken');
  }

  Future<void> _initPushNotifications() async {
    /// Essential for iOS foreground notification
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Execute [handleMessage] when app open from terminated state via notification
    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);

    /// Execute [handleMessage] when app open from background state via notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    /// Listen to foreground push notification
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen to background push notification
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  /// Essential for android foreground notification
  Future<void> _initLocalNotifications() async {
    const settings = InitializationSettings(
      iOS: DarwinInitializationSettings(),
      android: AndroidInitializationSettings('ic_launcher'),
    );
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onForegroundMessageSelected,
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  // Get message when notification pressed while app in foreground
  void _onForegroundMessageSelected(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;
    final message = RemoteMessage.fromMap(jsonDecode(payload));
    _handleMessage(message);
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          groupKey: _androidChannel.groupId,
          icon: 'ic_launcher',
        ),
      ),
      payload: jsonEncode(message.toMap()),
    );

    _printMessageData(message);
  }

  void cancelAll() => _localNotifications.cancelAll();

  /// Handling message when app open from notification
  /// terminated, background and foreground states
  /// Do some actions depend on message data
  void _handleMessage(RemoteMessage? message) async {
    debugPrint('PushType ===> _onMessageOpenedApp');
    if (message == null) return;
    final data = message.data;
    switch (data['type']) {
      case FirebaseCollections.chats:
        final doc = data['doc'];
        if (openChatDoc != doc) {
          final chat = ChatModel(
            doc: doc,
            id: int.parse(data['id']),
            name: data['name'],
            image: data['image'],
          );
          _goto(ChatView(chat));
          _ref.read(selectedPageProvider.notifier).state = 2;
        }
    }
    _printMessageData(message);
  }

  void _goto(Widget page) {
    final context = navigatorKey.currentContext;
    context!.push(page);
  }
}

void _printMessageData(RemoteMessage message) {
  debugPrint('''
  Notification Title ===> ${message.notification?.title}
  Notification Body ===> ${message.notification?.body}
  Notification Payload ===> ${message.data}
      ''');
}
