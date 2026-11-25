import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/app_badge_service.dart';
import 'package:mizan/app/app_logger.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/data/local/token_local_data_source.dart';
import 'package:mizan/domain/use_case/register_device_use_case.dart';
import 'package:mizan/domain/use_case/unregister_device_use_case.dart';
import 'package:mizan/presentation/notifications/notifications_cubit/notifications_cubit.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // تحديث الـ badge في الخلفية عند وصول إشعار جديد
  try {
    await AppBadgeService.incrementBadge();
  } catch (_) {}

  // عرض الإشعار بالوقت الحالي عند وصوله والهاتف مغلق أو التطبيق في الخلفية
  try {
    final String title = message.notification?.title ??
        message.data['title'] as String? ??
        'تنبيه ميزان';
    final String body = message.notification?.body ??
        message.data['body'] as String? ??
        '';

    if (title.isNotEmpty || body.isNotEmpty) {
      final FlutterLocalNotificationsPlugin localNotifications =
          FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
      );
      await localNotifications.initialize(initSettings);

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        NotificationService.channelId,
        NotificationService.channelName,
        description: NotificationService.channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      final int now = DateTime.now().millisecondsSinceEpoch;

      final AndroidNotificationDetails androidDetails =
          NotificationService.createAndroidDetails(when: now);

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      final int notificationId =
          (message.messageId ?? now.toString()).hashCode;

      await localNotifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: message.data['screen'] as String? ?? 'notifications',
      );

      // النظام ممكن يعرض نسخته الخاصة من إشعار FCM (بوقت غلط). نشيل أي نسخة
      // بنفس العنوان والنص ومش بتاعتنا، ونسيب النسخة المحلية بوقت الموبايل.
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          localNotifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      for (final int delayMs in <int>[0, 400, 1200]) {
        if (delayMs > 0) {
          await Future<void>.delayed(Duration(milliseconds: delayMs));
        }
        final List<ActiveNotification> active =
            await androidPlugin?.getActiveNotifications() ??
            <ActiveNotification>[];
        for (final ActiveNotification n in active) {
          if (n.id != notificationId && n.title == title && n.body == body) {
            await localNotifications.cancel(n.id ?? 0, tag: n.tag);
          }
        }
      }
    }
  } catch (e) {
    debugPrint('Background notification display error: $e');
  }
}

@lazySingleton
class NotificationService {
  final TokenLocalDataSource _tokenLocalDataSource;
  final RegisterDeviceUseCase _registerDeviceUseCase;
  final UnregisterDeviceUseCase _unregisterDeviceUseCase;

  NotificationService(
    this._tokenLocalDataSource,
    this._registerDeviceUseCase,
    this._unregisterDeviceUseCase,
  );

  static const String channelId = 'mizan_reminders';
  static const String channelName = 'Mizan Reminders';
  static const String channelDescription = 'تذكيرات ومواعيد استحقاق ميزان';

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;

  String? _cachedToken;

  Future<void> initialize() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );

    _messageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );

    final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    } else {
      final NotificationAppLaunchDetails? launchDetails =
          await _localNotifications.getNotificationAppLaunchDetails();
      if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
        _navigateToNotificationsScreen();
      }
    }

    _tokenRefreshSubscription = _fcm.onTokenRefresh.listen((
      String newToken,
    ) async {
      _cachedToken = newToken;
      if (kDebugMode) {
        debugPrint('FCM Token Refreshed: $newToken');
      }
      final bool isAuthenticated = await _tokenLocalDataSource
          .hasValidSession();
      if (isAuthenticated) {
        await _registerDeviceUseCase.execute(
          RegisterDeviceInput(token: newToken, platform: 'Android'),
        );
      }
    });
  }

  static AndroidNotificationDetails createAndroidDetails({int? when}) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      showWhen: true,
      when: when ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    _navigateToNotificationsScreen();
  }

  void _handleNotificationTap(RemoteMessage message) {
    _navigateToNotificationsScreen();
  }

  void _navigateToNotificationsScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final NavigatorState? navState = Routes.navigatorKey.currentState;
      if (navState != null) {
        navState.pushNamed(Routes.notificationsRoute);
      }
    });
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final String title = notification?.title ??
        message.data['title'] as String? ??
        'تنبيه ميزان';
    final String body = notification?.body ??
        message.data['body'] as String? ??
        '';

    final NotificationDetails notificationDetails = NotificationDetails(
      android: createAndroidDetails(),
    );

    final int notificationId =
        (message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString())
            .hashCode;

    await _localNotifications.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: message.data['screen'] as String? ?? 'notifications',
    );

    // تحديث عدد الإشعارات والـ badge فوراً عند وصول إشعار جديد (foreground)
    _refreshNotificationCount();
  }

  /// يُحدّث عدد الإشعارات غير المقروءة في الـ cubit والـ badge الخارجي
  void _refreshNotificationCount() {
    try {
      if (getIt.isRegistered<NotificationsCubit>()) {
        getIt<NotificationsCubit>().fetchUnreadCount();
      }
    } catch (e) {
      AppLogger.e('Failed to refresh notification count', error: e);
    }
  }

  /// يُستدعى عند العودة للتطبيق (resume) لإعادة مزامنة العدد
  Future<void> refreshOnAppResume() async {
    _refreshNotificationCount();
  }

  /// Registers device token ONLY if authenticated.
  Future<void> registerDeviceToken() async {
    final bool isAuthenticated = await _tokenLocalDataSource.hasValidSession();
    if (!isAuthenticated) return;

    try {
      final NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        final String? token = await _fcm.getToken();
        if (token != null) {
          _cachedToken = token;
          if (kDebugMode) {
            if (kDebugMode) debugPrint('FCM Token: $token');
          }
          await _registerDeviceUseCase.execute(
            RegisterDeviceInput(token: token, platform: 'Android'),
          );
        }
      }
    } catch (e) {
      AppLogger.e('Failed to register device token', error: e);
    }
  }

  /// Returns the current FCM token (cached or fetched)
  Future<String?> getDeviceToken() async {
    if (_cachedToken != null) return _cachedToken;
    try {
      _cachedToken = await _fcm.getToken();
      return _cachedToken;
    } catch (_) {
      return null;
    }
  }

  /// Unregisters the token from backend
  Future<void> unregisterDeviceToken() async {
    try {
      final String? token = await getDeviceToken();
      if (token != null && token.isNotEmpty) {
        await _unregisterDeviceUseCase.execute(token);
      }
    } catch (e) {
      AppLogger.e('Failed to unregister device token', error: e);
    }
  }

  /// Deletes local FCM token
  Future<void> deleteLocalDeviceToken() async {
    try {
      await _fcm.deleteToken();
      _cachedToken = null;
    } catch (e) {
      AppLogger.e('Failed to delete local FCM token', error: e);
    }
  }

  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _foregroundMessageSubscription?.cancel();
    _messageOpenedAppSubscription?.cancel();
  }
}
