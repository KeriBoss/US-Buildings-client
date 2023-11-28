import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:us_building_client/views/layout/layout.dart';

@RoutePage()
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Container(
        child: const Center(
          child: Text('Contact'),
        ),
      ),
    );
  }
}
