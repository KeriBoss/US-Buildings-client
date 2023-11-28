import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/service_model.dart';
import '../../views/screens/account_screen.dart';
import '../../views/screens/booking_screen.dart';
import '../../views/screens/contact_screen.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/index_screen.dart';
import '../../views/screens/order_list_screen.dart';
import '../../views/screens/phone_otp_verification_screen.dart';
import '../../views/screens/register_screen.dart';
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
          page: BookingRoute.page,
          path: AppRouterPath.booking,
        ),
        AutoRoute(
          page: HomeRoute.page,
          path: AppRouterPath.home,
          initial: true,
        ),
        AutoRoute(
          page: BookingRoute.page,
          path: AppRouterPath.booking,
        ),
        AutoRoute(
          page: ContactRoute.page,
          path: AppRouterPath.contact,
        ),
        AutoRoute(
          page: AccountRoute.page,
          path: AppRouterPath.account,
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
          page: PhoneOtpVerificationRoute.page,
          path: AppRouterPath.phoneOtpVerification,
        ),
      ];
}
