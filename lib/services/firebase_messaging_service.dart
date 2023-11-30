import 'dart:isolate';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:us_building_client/views/screens/webview_screen.dart';

import '../main.dart';

class FirebaseMessagingService extends ChangeNotifier {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService() {
    return _instance;
  }

  FirebaseMessagingService._internal();

  ReceivedAction? initialAction;
  static ReceivePort? receivePort;

  static Future<void> initializeLocalNotifications({
    required bool debug,
  }) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'remoteNotification',
          channelName: 'Remote notification',
          channelDescription: 'Notification alerts',
          playSound: true,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple,
        )
      ],
      debug: debug,
    );

    _instance.initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> initializeRemoteNotifications({
    required bool debug,
  }) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: mySilentDataHandle,
      onFcmTokenHandle: myFcmTokenHandle,
      onNativeTokenHandle: myNativeTokenHandle,
      licenseKeys: null,
      debug: debug,
    );
  }

  static Future<void> startListeningNotificationEvents(
    BuildContext context,
  ) async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (receivedAction) => onActionReceivedMethod(
        receivedAction,
        context,
      ),
    );
  }

  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
        (silentData) => MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (BuildContext context) => const WebViewScreen(),
          ),
        ),
      );

    IsolateNameServer.registerPortWithName(
      receivePort!.sendPort,
      'notification_action_port',
    );
  }

  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;
    debugPrint('App launched by a notification action: $receivedAction');

    MyApp.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext context) => const WebViewScreen(),
      ),
    );
  }

  static Future<void> onActionReceivedImplementationMethod(
    ReceivedAction receivedAction,
    BuildContext context,
  ) async {
    context.router.pushWidget(WebViewScreen());
  }

  /// Use this to handle on click push notification event
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
    BuildContext context,
  ) async {
    debugPrint('Pressed on Notification');
    print(receivedAction.toMap());
    debugPrint('Title: ${receivedAction.title ?? 'NULL'}');
    debugPrint('Body: ${receivedAction.body ?? 'NULL'}');
    debugPrint('Large icon url: ${receivedAction.largeIcon ?? 'NULL'}');
    debugPrint('Big image url: ${receivedAction.bigPicture ?? 'NULL'}');
    debugPrint('Data: ${receivedAction.payload ?? 'NULL'}');
    debugPrint('Channel key: ${receivedAction.channelKey ?? 'NULL'}');

    return onActionReceivedImplementationMethod(receivedAction, context);
  }

  /// Use this method to execute on background when a silent data arrives (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    print('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print("BACKGROUND");
    } else {
      print("FOREGROUND");
    }

    print("starting long task...");
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    debugPrint('FCM Token:"$token"');
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token:"$token"');
  }

  static Future<void> checkPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        final token = await AwesomeNotificationsFcm().requestFirebaseAppToken();
        debugPrint('==================My FCM Token==================');
        debugPrint(token);
        debugPrint('=============================================');
        return token;
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.hashCode,
        channelKey: "high_importance_channel",
        title: message.data['title'],
        body: message.data['body'],
        bigPicture: message.data['image'],
        notificationLayout: NotificationLayout.BigPicture,
        largeIcon: message.data['image'],
        payload: Map<String, String>.from(message.data),
        hideLargeIconOnExpand: true,
      ),
    );
  }
}
