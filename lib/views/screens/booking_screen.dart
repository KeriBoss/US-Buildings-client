import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/views/screens/order_list_screen.dart';
import 'package:us_building_client/views/screens/service_booking_screen.dart';

import '../layout/layout.dart';

@RoutePage()
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 40.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.radius),
                      bottomRight: Radius.circular(50.radius),
                    ),
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      ServiceBookingScreen(),
                      OrderListScreen(),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.width),
              height: 60.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 5),
                    spreadRadius: 4,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.radius),
                  topRight: Radius.circular(5.radius),
                  bottomLeft: Radius.circular(20.radius),
                  bottomRight: Radius.circular(20.radius),
                ),
              ),
              child: TabBar(
                automaticIndicatorColorAdjustment: false,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.radius),
                  topRight: Radius.circular(5.radius),
                  bottomLeft: Radius.circular(20.radius),
                  bottomRight: Radius.circular(20.radius),
                ),
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.radius),
                    topRight: Radius.circular(5.radius),
                    bottomLeft: Radius.circular(20.radius),
                    bottomRight: Radius.circular(20.radius),
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.size,
                ),
                unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.size,
                ),
                labelColor: Theme.of(context).colorScheme.onPrimary,
                tabs: const [
                  Tab(
                    text: 'ĐẶT LỊCH',
                  ),
                  Tab(
                    text: 'ĐƠN HÀNG',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
