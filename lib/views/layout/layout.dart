import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:us_building_client/data/static/app_value.dart';

import '../../core/router/app_router_config.dart';

class Layout extends StatefulWidget {
  const Layout({super.key, required this.body, this.canBack = false});

  final Widget body;
  final bool canBack;

  @override
  State<StatefulWidget> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final List<PageRouteInfo<dynamic>> _routeList = const [
    HomeRoute(),
    BookingRoute(),
    ContactRoute(),
    AccountRoute(),
  ];

  void _selectBottomIconButton(int index) {
    context.router.replaceAll([_routeList[index]]);

    AppValue.currentBottomBarIndex = index;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: widget.canBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.router.pop();
                },
              )
            : null,
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        currentIndex: AppValue.currentBottomBarIndex,
        showUnselectedLabels: true,
        onTap: _selectBottomIconButton,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.secondary,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
              color: Theme.of(context).colorScheme.secondary,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            label: 'Đặt lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apartment,
              color: Theme.of(context).colorScheme.secondary,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            label: 'Liên hê',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            label: 'Tài khoản',
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: context.router.current.path == AppRouterPath.home
      //     ? Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 15.width),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             FloatingActionButton(
      //               onPressed: () {},
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(100.radius),
      //               ),
      //               child: Icon(
      //                 Icons.message_rounded,
      //                 color: Theme.of(context).colorScheme.secondary,
      //               ),
      //             ),
      //             FloatingActionButton(
      //               onPressed: () {},
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(100.radius),
      //               ),
      //               child: Icon(
      //                 Icons.phone,
      //                 color: Theme.of(context).colorScheme.secondary,
      //               ),
      //             )
      //           ],
      //         ),
      //       )
      //     : null,
    );
  }
}
