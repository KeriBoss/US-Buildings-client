import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/bloc/service/service_bloc.dart';
import 'package:us_building_client/data/repositories/service_repository.dart';

import 'core/config/dio_config.dart';
import 'core/config/http_client_config.dart';
import 'core/router/app_router_config.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

const webServerKey =
    'AAAAQJpgCU0:APA91bHQqqNEIxQa-By-XYL02dexwUaKEdCVKWO2yhw7oAXMUC7OKznvM6gpBGhFzsfoP_l104eGmQ7xpDha9_ZPpNVE7BdZMuNySabKQ59V7ZDkGrDRoa7s1wl_S4kvnOYIApmdGCXP';
final Dio dio = Dio();
final AppRouter appRouter = AppRouter();

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

final localNotification = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  HttpOverrides.global = HttpClientConfig();

  DioConfig.configBasicOptions(dio);
  DioConfig.configInterceptors(dio);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServiceRepository>(
          create: (context) => ServiceRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ServiceBloc>(
            create: (context) => ServiceBloc(
              RepositoryProvider.of<ServiceRepository>(context),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter.config(),
          debugShowCheckedModeBanner: false,
          theme: appTheme,
        );
      },
    );
  }
}
