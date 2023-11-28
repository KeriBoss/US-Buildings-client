import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/bloc/authorization/authorization_bloc.dart';
import 'package:us_building_client/bloc/service/service_bloc.dart';
import 'package:us_building_client/data/repositories/authorization_repository.dart';
import 'package:us_building_client/data/repositories/service_repository.dart';
import 'package:us_building_client/services/firebase_messaging_service.dart';

import 'bloc/webview/webview_bloc.dart';
import 'core/config/dio_config.dart';
import 'core/config/http_client_config.dart';
import 'core/router/app_router_config.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

const apiKey = 'AIzaSyAORtYhclWmVTCjaK9-rDJmNx0A4U7O7qY';
const webServerKey =
    'AAAAA7lT6kE:APA91bEWMGqhsy3aaxQQLpEp37k8Tt622jWWrFZbfeujPl-fuxxSI0ihn-u6YbqKy_M7PJIs_rKbtpe-aAwYUPvoT7DZ_y5PdEszX8R-4Q0vmn9NnGwYQBtbwlO_vlesdyPM-XYZkYiz';

final Dio dio = Dio();
final AppRouter appRouter = AppRouter();

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// handle event of message at background
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage? message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseMessageService.runWhileAppIsTerminated();
  //
  // await FirebaseMessageService.initFirebaseMessagePushNotifications();
  // await FirebaseMessageService.initLocalNotifications();
}

Future<void> main() async {
  HttpOverrides.global = HttpClientConfig();

  DioConfig.configBasicOptions(dio);
  DioConfig.configInterceptors(dio);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(
    FirebaseMessagingService.firebaseMessagingBackgroundHandler,
  );

  await FirebaseMessagingService.initializeLocalNotifications(debug: true);
  await FirebaseMessagingService.initializeRemoteNotifications(debug: true);
  await FirebaseMessagingService.initializeIsolateReceivePort();
  await FirebaseMessagingService.getInitialNotificationAction();
  // FirebaseMessageService.runWhileAppIsTerminated();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServiceRepository>(
          create: (context) => ServiceRepository(),
        ),
        RepositoryProvider<AuthorizationRepository>(
          create: (context) => AuthorizationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ServiceBloc>(
            create: (context) => ServiceBloc(
              RepositoryProvider.of<ServiceRepository>(context),
            ),
          ),
          BlocProvider<AuthorizationBloc>(
            create: (context) => AuthorizationBloc(
              RepositoryProvider.of<AuthorizationRepository>(context),
            ),
          ),
          BlocProvider<WebviewBloc>(
            create: (context) => WebviewBloc(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessagingService.checkPermission();
    FirebaseMessagingService.requestFirebaseToken();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          key: navigatorKey,
          routerConfig: appRouter.config(),
          debugShowCheckedModeBanner: false,
          theme: appTheme,
        );
      },
    );
  }
}
