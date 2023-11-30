import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/service_model.dart';
import '../../data/models/service_order_model.dart';
import '../../views/screens/account_screen.dart';
import '../../views/screens/booking_screen.dart';
import '../../views/screens/contact_screen.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/index_screen.dart';
import '../../views/screens/map_screen.dart';
import '../../views/screens/order_list_screen.dart';
import '../../views/screens/phone_otp_verification_screen.dart';
import '../../views/screens/register_screen.dart';
import '../../views/screens/schedule_screen.dart';
import '../../views/screens/searching_screen.dart';
import '../../views/screens/service_booking_screen.dart';
import '../../views/screens/service_list_screen.dart';
import '../../views/screens/webview_screen.dart';
import 'app_router_path.dart';

part 'app_router_config.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: IndexRoute.page,
          path: AppRouterPath.index,
          children: [
            AutoRoute(
              page: HomeRoute.page,
              path: AppRouterPath.home,
            ),
            AutoRoute(
              page: ScheduleRoute.page,
              path: AppRouterPath.schedule,
            ),
            AutoRoute(
              page: ContactRoute.page,
              path: AppRouterPath.contact,
            ),
            AutoRoute(
              page: AccountRoute.page,
              path: AppRouterPath.account,
            ),
          ],
          initial: true,
        ),
        AutoRoute(
          page: BookingRoute.page,
          path: AppRouterPath.booking,
        ),
        AutoRoute(
          page: ServiceListRoute.page,
          path: AppRouterPath.serviceList,
        ),
        AutoRoute(
          page: WebViewRoute.page,
          path: AppRouterPath.webview,
        ),
        AutoRoute(
          page: RegisterRoute.page,
          path: AppRouterPath.register,
        ),
        AutoRoute(
          page: BookingRoute.page,
          path: AppRouterPath.booking,
        ),
        AutoRoute(
          page: PhoneOtpVerificationRoute.page,
          path: AppRouterPath.phoneOtpVerification,
        ),
        AutoRoute(
          page: MapRoute.page,
          path: AppRouterPath.map,
        ),
        AutoRoute(
          page: SearchingRoute.page,
          path: AppRouterPath.searching,
        ),
      ];
}
