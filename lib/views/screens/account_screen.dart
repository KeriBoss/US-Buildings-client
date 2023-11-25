import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:us_building_client/views/layout/layout.dart';
import 'package:us_building_client/views/screens/webview_screen.dart';

import '../../bloc/webview/webview_bloc.dart';
import '../../core/router/app_router_path.dart';
import '../widgets/gradient_button.dart';

@RoutePage()
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Center(
        child: Column(
          children: [
            GradientElevatedButton(
              text: 'Đăng Kí',
              buttonMargin: EdgeInsets.zero,
              onPress: () {
                context.router.pushNamed(AppRouterPath.register);
              },
            ),
            GradientElevatedButton(
              text: 'Đăng nhập',
              buttonMargin: EdgeInsets.zero,
              onPress: () {
                context.read<WebviewBloc>().add(
                      OnLoadWebviewEvent(
                          'http://34.67.65.197:8080/usbuildings/'),
                    );

                context.router.pushWidget(WebViewScreen(code: ''));
              },
            ),
          ],
        ),
      ),
    );
  }
}
