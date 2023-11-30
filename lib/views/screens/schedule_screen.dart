import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Schedule'),
    );
  }
}
