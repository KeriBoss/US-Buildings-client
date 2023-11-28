import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:us_building_client/views/screens/webview_screen.dart';

import '../data/static/enum/local_storage_enum.dart';
import '../main.dart';
import 'local_storage_service.dart';

class FirebaseMessageService {
  final BuildContext context;

  FirebaseMessageService(this.context);

  Future<void> initNotifications() async {
    // request for permission to get notifications from app
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (Platform.isIOS) {
      final fcmToken = await firebaseMessaging.getAPNSToken();
      debugPrint('APNS token: $fcmToken');
    }

    // get FCM token for this device
    final fcmToken = await firebaseMessaging.getToken();
    debugPrint('FCM token: $fcmToken');

    // cache phone fcm token
    LocalStorageService.setLocalStorageData(
      LocalStorageEnum.phoneToken.name,
      fcmToken,
    );

    // subscribe to a topic to get messages from that topic
    firebaseMessaging.subscribeToTopic('all');

    initFirebaseMessagePushNotifications();
    initLocalNotifications();

    debugPrint('Finish notification initiation');
  }

  // handle events from Firebase message notification
  Future initFirebaseMessagePushNotifications() async {
    try {
      // user for IOS, config foreground message options
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // event handler when application is opened from terminated state
      firebaseMessaging.getInitialMessage().then((message) async {
        if (message != null) {
          FlutterAppBadger.removeBadge();

          debugPrint('Title: ${message.notification?.title}');
          debugPrint('Body: ${message.notification?.body}');
          debugPrint('Data: ${message.data}');

          context.router.pushWidget(WebViewScreen(
            url: message.data['link'],
          ));
        } else {
          debugPrint('No message from terminated state');
        }
      });

      // event handler when user press on the message
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        FlutterAppBadger.removeBadge();

        debugPrint('Title: ${message.notification?.title}');
        debugPrint('Body: ${message.notification?.body}');
        debugPrint('Data: ${message.data}');

        appRouter.pushWidget(WebViewScreen(
          url: message.data['link'],
        ));
      });

      // application gets a message when it is in the background or terminated
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // event handler when application gets a message on foreground
      FirebaseMessaging.onMessage.listen((message) async {
        FlutterAppBadger.updateBadgeCount(1);

        final notification = message.notification;

        // get image from internet, then parse the base64 code the response to the notification for it to show the image
        Map<String, dynamic> msgMapData = message.data;

        String? imgUrl = msgMapData['image'] as String?;
        String? iconUrl = msgMapData['icon'] as String?;

        AndroidNotificationDetails? androidNotificationDetails;
        DarwinNotificationDetails? darwinNotificationDetails;

        if (Platform.isIOS) {
          final String? bigImgFilePath =
              await LocalStorageService.downloadAndSavePicture(
            url: imgUrl,
          );

          final String? iconFilePath =
              await LocalStorageService.downloadAndSavePicture(
            url: iconUrl,
          );

          darwinNotificationDetails = DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            attachments: [
              if (bigImgFilePath != null) ...[
                DarwinNotificationAttachment(
                  bigImgFilePath,
                ),
              ],
            ],
          );
        } else if (Platform.isAndroid) {
          BigPictureStyleInformation? bigPictureStyleInformation;

          // big image can not be null, icon can be null
          if (imgUrl != null && imgUrl.isNotEmpty) {
            final http.Response imgResponse = await http.get(Uri.parse(imgUrl));
            http.Response? iconResponse = iconUrl != null && iconUrl.isNotEmpty
                ? await http.get(Uri.parse(iconUrl))
                : null;

            bigPictureStyleInformation = iconResponse != null
                ? BigPictureStyleInformation(
                    ByteArrayAndroidBitmap.fromBase64String(
                      base64Encode(
                        imgResponse.bodyBytes,
                      ),
                    ),
                    largeIcon: ByteArrayAndroidBitmap.fromBase64String(
                      base64Encode(
                        iconResponse.bodyBytes,
                      ),
                    ),
                  )
                : BigPictureStyleInformation(
                    ByteArrayAndroidBitmap.fromBase64String(
                      base64Encode(
                        imgResponse.bodyBytes,
                      ),
                    ),
                  );
          }

          androidNotificationDetails = AndroidNotificationDetails(
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            icon: '@drawable/ic_launcher',
            styleInformation: bigPictureStyleInformation,
          );
        }

        if (notification != null) {
          localNotification.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: androidNotificationDetails,
              iOS: darwinNotificationDetails,
            ),
            payload: jsonEncode(message.toMap()),
          );
        }
      });
    } catch (e, stackTrace) {
      debugPrint('Caught error: ${e.toString()} \n${stackTrace.toString()}');
    }
  }

  // handle events from local notification
  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const ios = DarwinInitializationSettings();
    const setting = InitializationSettings(android: android, iOS: ios);

    // init local notification settings for both platforms
    await localNotification.initialize(
      setting,
      // handle on press message event
      onDidReceiveNotificationResponse: (notiResponse) {
        Map<String, dynamic> jsonMap = jsonDecode(notiResponse.payload!);

        final message = RemoteMessage.fromMap(jsonMap);

        debugPrint('Pressed on pushed message');
        debugPrint('Title: ${message.notification?.title}');
        debugPrint('Body: ${message.notification?.body}');
        debugPrint('Data: ${message.data}');
        debugPrint('Payload: ${jsonDecode(notiResponse.payload!)}');

        appRouter.pushWidget(WebViewScreen(
          url: message.data['link'],
        ));
      },
      // onDidReceiveBackgroundNotificationResponse: handleBackgroundLocalMessage,
    );

    final platform = localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(androidChannel);
  }

  void runWhileAppIsTerminated() async {
    final details = await localNotification.getNotificationAppLaunchDetails();

    if (details!.didNotificationLaunchApp) {
      if (details.notificationResponse!.payload != null) {
        Map<String, dynamic> jsonMap = jsonDecode(
          details.notificationResponse!.payload!,
        );

        appRouter.pushWidget(WebViewScreen(
          url: jsonMap['link'],
        ));
      }
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    await firebaseMessaging
        .subscribeToTopic(topic)
        .then((value) => debugPrint('Subscribed to topic: $topic'));
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await firebaseMessaging
        .unsubscribeFromTopic(topic)
        .then((value) => debugPrint('Unsubscribed from topic: $topic'));
  }

  static Future<void> sendMessage({
    Map<String, dynamic>? data,
    required String title,
    required String content,
    String? receiverToken,
    String? topic,
  }) async {
    // if (token.isEmpty) {
    //   debugPrint('Unable to send FCM message, no token exists.');
    //   return;
    // }
    Map<String, dynamic> dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      'fromPhoneToken': await LocalStorageService.getLocalStorageData(
        LocalStorageEnum.phoneToken.name,
      ) as String,
    };

    if (data != null) {
      dataMap.addAll(data);
    }

    Map<String, dynamic> payload = {
      'data': dataMap,
      'notification': {
        'title': title,
        'body': content,
      },
    };

    if (receiverToken != null && receiverToken.isNotEmpty) {
      payload['to'] = receiverToken;
    } else if (topic != null && topic.isNotEmpty) {
      payload['to'] = '/topics/$topic';
    }

    String payloadString = payload.toString();
    debugPrint(payloadString);

    try {
      await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$webServerKey',
        }),
        data: payload,
      );

      debugPrint('FCM request for device sent!');
    } catch (e, stackTrace) {
      debugPrint('Caught ${e.toString()} \n${stackTrace.toString()}');
    }
  }
}
