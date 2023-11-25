import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:us_building_client/core/extension/number_extension.dart';

import '../../core/router/app_router_config.dart';

@RoutePage()
class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<StatefulWidget> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        HomeRoute(),
        BookingRoute(),
        ContactRoute(),
        AccountRoute(),
      ],
      builder: (context, child, pageController) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            currentIndex: pageController.initialPage,
            onTap: tabsRouter.setActiveIndex,
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
                  Icons.logo_dev_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: 'Tiện ích',
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AutoTabsRouter.of(context).activeIndex == 0
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.width),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.radius),
                        ),
                        child: Icon(
                          Icons.message_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.radius),
                        ),
                        child: const Icon(Icons.phone),
                      )
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }
}
