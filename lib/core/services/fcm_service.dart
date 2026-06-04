import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/routers/app_router.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:new_mama/feature/notifications/domain/usecases/device_token_usecases.dart';
import 'package:new_mama/core/utils/notification_router.dart';
import 'package:new_mama/firebase_options.dart';

/// Top-level background message handler (must be outside any class).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized inside the background isolate as it runs in its own context.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    log('[FCM] Error initializing Firebase in background isolate: $e');
  }

  // FCM automatically displays notification messages when the app is in the background or closed.
  // DO NOT call FcmService._showLocalNotification here as it causes duplicate notifications.
  // Use this handler only for silent data processing or custom background tasks.
  log('[FCM] Background message received: ${message.messageId}');
}

class FcmService {
  FcmService._();

  static final _messaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _channelId = 'momease_notifications';
  static const _channelName = 'MomEase Notifications';
  static const _channelDesc = 'MomEase push notification channel';

  static bool _isInitialized = false;

  static Map<String, dynamic>? _pendingNotificationData;

  //  Init 

  /// Call once from main(), after AppRouter.initRouter().
  static Future<void> init() async {
    if (_isInitialized) return;

    await _requestPermission();
    await _initLocalNotifications();
    _listenForeground();
    _listenOnOpenedApp();
    _listenTokenRefresh();
    await _checkInitialMessage();
    await _registerCurrentTokenIfLoggedIn();

    _isInitialized = true;
  }

  //  Permission 

  static Future<void> _requestPermission() async {
    // 1. Request FCM / APNs permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('[FCM] Permission status: ${settings.authorizationStatus}');

    // 2. Request Android 13+ Notification Permission via Local Notifications
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        log('[FCM] Android local notification permission granted: $granted');
      }
    }
  }

  //  Token 

  /// Returns the current FCM token, or null if unavailable.
  static Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      log('[FCM] Token: $token');
      return token;
    } catch (e) {
      log('[FCM] Failed to get token: $e');
      return null;
    }
  }

  /// Safely attempts to register the current FCM token with the backend if the user is logged in.
  static Future<void> _registerCurrentTokenIfLoggedIn() async {
    try {
      final authLocalDataSource = getIt<AuthLocalDataSource>();
      final tokens = await authLocalDataSource.getTokens();
      if (tokens != null) {
        log('[FCM] User is logged in. Registering/verifying current FCM token on backend.');
        final currentToken = await getToken();
        if (currentToken != null) {
          final registerDeviceTokenUseCase = getIt<RegisterDeviceTokenUseCase>();
          final result = await registerDeviceTokenUseCase(currentToken);
          result.fold(
            (failure) => log('[FCM] Failed to register current token on backend: ${failure.message}'),
            (msg) => log('[FCM] Current token registered/verified on backend: $msg'),
          );
        }
      } else {
        log('[FCM] User is not logged in. Skipping token registration.');
      }
    } catch (e) {
      log('[FCM] Error checking login status for token registration: $e');
    }
  }

  /// Listens for FCM token refreshes and synchronizes them with the backend repository.
  static void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      log('[FCM] Token refreshed: $newToken');
      try {
        final registerDeviceTokenUseCase = getIt<RegisterDeviceTokenUseCase>();
        final result = await registerDeviceTokenUseCase(newToken);
        result.fold(
          (failure) => log('[FCM] Failed to update refreshed token on backend: ${failure.message}'),
          (msg) => log('[FCM] Refreshed token successfully updated on backend: $msg'),
        );
      } catch (e, stackTrace) {
        log(
          '[FCM] Exception while updating refreshed token on backend',
          error: e,
          stackTrace: stackTrace,
          name: 'FcmService',
        );
      }
    });
  }

  //  Local notifications 

  static Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(payload);
            _handleNotificationTap(data);
          } catch (e) {
            log('[FCM] Error parsing local notification payload: $e');
          }
        }
      },
    );

    // Create Android notification channel.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDesc,
            importance: Importance.max,
            playSound: true,
          ),
        );
  }

  /// Shows a local notification from a [RemoteMessage].
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    String? title;
    String? body;

    final notification = message.notification;
    if (notification != null) {
      title = notification.title;
      body = notification.body;
    } else {
      // Handle data-only messages containing title and body in the data payload
      title = message.data['title']?.toString();
      body = message.data['body']?.toString();
    }

    // If both are empty, it's a silent data message (no banner should be shown)
    if (title == null && body == null) {
      log('[FCM] Silent data message received. No notification shown.');
      return;
    }

    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);

    final data = Map<String, dynamic>.from(message.data);
    data['title'] ??= title;
    data['body'] ??= body;

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      details,
      payload: jsonEncode(data),
    );
  }

  //  Listeners 

  /// Listens for messages when the app is in the foreground.
  static void _listenForeground() {
    // Prevent native duplicate banners on iOS when using local notifications
    _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    FirebaseMessaging.onMessage.listen((message) {
      log('[FCM] Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });
  }

  /// Handles notification tap when the app is in the background (not terminated).
  static void _listenOnOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('[FCM] Opened from background: ${message.data}');
      final data = Map<String, dynamic>.from(message.data);
      if (message.notification != null) {
        data['title'] ??= message.notification!.title;
        data['body'] ??= message.notification!.body;
      }
      _handleNotificationTap(data);
    });
  }

  /// Handles notification tap when the app was terminated.
  static Future<void> _checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      log('[FCM] Opened from terminated: ${message.data}');
      final data = Map<String, dynamic>.from(message.data);
      if (message.notification != null) {
        data['title'] ??= message.notification!.title;
        data['body'] ??= message.notification!.body;
      }
      _handleNotificationTap(data);
    }
  }

  /// Centralized Notification Tap Router with safe polling retry limit and advanced diagnostics.
  static void _handleNotificationTap(Map<String, dynamic> data) {
    log('[FCM] Handling notification tap with data: $data');
    _pendingNotificationData = data;
    _processPendingNotification(0);
  }

  /// Safe post-frame polling to resolve deep link navigation state.
  /// Standardizes deep linking and prevents infinite loops with a hard retry limit.
  static void _processPendingNotification(int attempt) {
    if (_pendingNotificationData == null) return;

    final navigatorState = AppRouter.router.routerDelegate.navigatorKey.currentState;
    if (navigatorState != null) {
      final data = _pendingNotificationData!;
      _pendingNotificationData = null;

      final context = navigatorState.context;
      final type = data['type']?.toString() ?? '';
      final actionUrl = data['actionUrl']?.toString();
      final relatedEntityIdStr = data['relatedEntityId']?.toString() ?? data['id']?.toString();
      final relatedEntityId = int.tryParse(relatedEntityIdStr ?? '');
      final title = data['title']?.toString() ?? '';
      final body = data['body']?.toString() ?? '';

      // Execute navigation after post-frame and a short delay to allow GoRouter's initial route navigation to settle.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 250), () {
          if (!context.mounted) return;
          try {
            NotificationRouter.navigate(
              context,
              actionUrl: actionUrl,
              type: type,
              relatedEntityId: relatedEntityId,
              title: title,
              body: body,
            );
          } catch (e, stackTrace) {
            log(
              '[FCM] Error executing notification tap navigation. Data: $data',
              error: e,
              stackTrace: stackTrace,
              name: 'FcmService',
            );
          }
        });
      });
    } else {
      if (attempt >= 10) {
        log('[FCM] Hard timeout reached: GoRouter Navigator is still null after 5 seconds. Deep link navigation aborted.', level: 900);
        _pendingNotificationData = null;
        return;
      }
      log('[FCM] Navigator state not ready yet. Retrying in 500ms (Attempt ${attempt + 1}/10).');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _processPendingNotification(attempt + 1);
        });
      });
    }
  }
}
