import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:us_building_client/core/router/app_router_config.dart';

class Layout extends StatefulWidget {
  const Layout({super.key, required this.body});

  final Widget body;

  @override
  State<StatefulWidget> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        IndexRoute(),
        IndexRoute(),
        IndexRoute(),
        IndexRoute(),
      ],
      builder: (context, child, _) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: widget.body,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                label: 'Trang chu',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.logo_dev_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                label: 'Tien ich',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.apartment,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                label: 'Lien he',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                label: 'Tai khoan',
              ),
            ],
          ),
        );
      },
    );
  }
}
