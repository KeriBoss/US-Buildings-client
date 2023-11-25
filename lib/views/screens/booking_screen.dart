import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:us_building_client/views/layout/layout.dart';

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
      body: Container(
        child: Center(
          child: Text('Booking'),
        ),
      ),
    );
  }
}
