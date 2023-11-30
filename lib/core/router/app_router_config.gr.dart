// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router_config.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountScreen(),
      );
    },
    BookingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BookingScreen(),
      );
    },
    ContactRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ContactScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    IndexRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IndexScreen(),
      );
    },
    MapRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MapScreen(),
      );
    },
    OrderListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrderListScreen(),
      );
    },
    PhoneOtpVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneOtpVerificationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PhoneOtpVerificationScreen(
          key: args.key,
          phoneNumber: args.phoneNumber,
          newServiceOrder: args.newServiceOrder,
        ),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterScreen(),
      );
    },
    ScheduleRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ScheduleScreen(),
      );
    },
    SearchingRoute.name: (routeData) {
      final args = routeData.argsAs<SearchingRouteArgs>(
          orElse: () => const SearchingRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchingScreen(
          key: args.key,
          isFromLocation: args.isFromLocation,
        ),
      );
    },
    ServiceBookingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServiceBookingScreen(),
      );
    },
    ServiceListRoute.name: (routeData) {
      final args = routeData.argsAs<ServiceListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServiceListScreen(
          key: args.key,
          serviceLv2: args.serviceLv2,
        ),
      );
    },
    WebViewRoute.name: (routeData) {
      final args = routeData.argsAs<WebViewRouteArgs>(
          orElse: () => const WebViewRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WebViewScreen(
          key: args.key,
          url: args.url,
        ),
      );
    },
  };
}

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BookingScreen]
class BookingRoute extends PageRouteInfo<void> {
  const BookingRoute({List<PageRouteInfo>? children})
      : super(
          BookingRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ContactScreen]
class ContactRoute extends PageRouteInfo<void> {
  const ContactRoute({List<PageRouteInfo>? children})
      : super(
          ContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IndexScreen]
class IndexRoute extends PageRouteInfo<void> {
  const IndexRoute({List<PageRouteInfo>? children})
      : super(
          IndexRoute.name,
          initialChildren: children,
        );

  static const String name = 'IndexRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapScreen]
class MapRoute extends PageRouteInfo<void> {
  const MapRoute({List<PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrderListScreen]
class OrderListRoute extends PageRouteInfo<void> {
  const OrderListRoute({List<PageRouteInfo>? children})
      : super(
          OrderListRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PhoneOtpVerificationScreen]
class PhoneOtpVerificationRoute
    extends PageRouteInfo<PhoneOtpVerificationRouteArgs> {
  PhoneOtpVerificationRoute({
    Key? key,
    required String phoneNumber,
    required ServiceOrderModel newServiceOrder,
    List<PageRouteInfo>? children,
  }) : super(
          PhoneOtpVerificationRoute.name,
          args: PhoneOtpVerificationRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
            newServiceOrder: newServiceOrder,
          ),
          initialChildren: children,
        );

  static const String name = 'PhoneOtpVerificationRoute';

  static const PageInfo<PhoneOtpVerificationRouteArgs> page =
      PageInfo<PhoneOtpVerificationRouteArgs>(name);
}

class PhoneOtpVerificationRouteArgs {
  const PhoneOtpVerificationRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.newServiceOrder,
  });

  final Key? key;

  final String phoneNumber;

  final ServiceOrderModel newServiceOrder;

  @override
  String toString() {
    return 'PhoneOtpVerificationRouteArgs{key: $key, phoneNumber: $phoneNumber, newServiceOrder: $newServiceOrder}';
  }
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ScheduleScreen]
class ScheduleRoute extends PageRouteInfo<void> {
  const ScheduleRoute({List<PageRouteInfo>? children})
      : super(
          ScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScheduleRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchingScreen]
class SearchingRoute extends PageRouteInfo<SearchingRouteArgs> {
  SearchingRoute({
    Key? key,
    bool isFromLocation = true,
    List<PageRouteInfo>? children,
  }) : super(
          SearchingRoute.name,
          args: SearchingRouteArgs(
            key: key,
            isFromLocation: isFromLocation,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchingRoute';

  static const PageInfo<SearchingRouteArgs> page =
      PageInfo<SearchingRouteArgs>(name);
}

class SearchingRouteArgs {
  const SearchingRouteArgs({
    this.key,
    this.isFromLocation = true,
  });

  final Key? key;

  final bool isFromLocation;

  @override
  String toString() {
    return 'SearchingRouteArgs{key: $key, isFromLocation: $isFromLocation}';
  }
}

/// generated route for
/// [ServiceBookingScreen]
class ServiceBookingRoute extends PageRouteInfo<void> {
  const ServiceBookingRoute({List<PageRouteInfo>? children})
      : super(
          ServiceBookingRoute.name,
          initialChildren: children,
        );

  static const String name = 'ServiceBookingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServiceListScreen]
class ServiceListRoute extends PageRouteInfo<ServiceListRouteArgs> {
  ServiceListRoute({
    Key? key,
    required ServiceModel serviceLv2,
    List<PageRouteInfo>? children,
  }) : super(
          ServiceListRoute.name,
          args: ServiceListRouteArgs(
            key: key,
            serviceLv2: serviceLv2,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceListRoute';

  static const PageInfo<ServiceListRouteArgs> page =
      PageInfo<ServiceListRouteArgs>(name);
}

class ServiceListRouteArgs {
  const ServiceListRouteArgs({
    this.key,
    required this.serviceLv2,
  });

  final Key? key;

  final ServiceModel serviceLv2;

  @override
  String toString() {
    return 'ServiceListRouteArgs{key: $key, serviceLv2: $serviceLv2}';
  }
}

/// generated route for
/// [WebViewScreen]
class WebViewRoute extends PageRouteInfo<WebViewRouteArgs> {
  WebViewRoute({
    Key? key,
    String? url,
    List<PageRouteInfo>? children,
  }) : super(
          WebViewRoute.name,
          args: WebViewRouteArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'WebViewRoute';

  static const PageInfo<WebViewRouteArgs> page =
      PageInfo<WebViewRouteArgs>(name);
}

class WebViewRouteArgs {
  const WebViewRouteArgs({
    this.key,
    this.url,
  });

  final Key? key;

  final String? url;

  @override
  String toString() {
    return 'WebViewRouteArgs{key: $key, url: $url}';
  }
}
