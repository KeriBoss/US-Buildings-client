import 'package:auto_route/auto_route.dart';

import '../../views/screens/account_screen.dart';
import '../../views/screens/booking_screen.dart';
import '../../views/screens/contact_screen.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/index_screen.dart';
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
            AutoRoute(path: AppRouterPath.home, page: HomeRoute.page),
            AutoRoute(path: AppRouterPath.booking, page: BookingRoute.page),
            AutoRoute(path: AppRouterPath.contact, page: ContactRoute.page),
            AutoRoute(path: AppRouterPath.account, page: AccountRoute.page),
          ],
          initial: true,
        ),
      ];
}
