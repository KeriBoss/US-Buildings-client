import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/views/widgets/gradient_button.dart';

import '../../data/static/app_value.dart';
import '../../main.dart';
import '../../services/firebase_sms_service.dart';
import '../../utils/ui_render.dart';

@RoutePage()
class PhoneOtpVerificationScreen extends StatefulWidget {
  const PhoneOtpVerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<StatefulWidget> createState() => _PhoneOtpVerificationScreenState();
}

class _PhoneOtpVerificationScreenState
    extends State<PhoneOtpVerificationScreen> {
  final GlobalKey<FormState> phoneVerifyFormKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  void _onPressVerifyButton() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: AppValue.verificationId ?? '',
        smsCode: _verificationCodeController.text,
      );

      await auth.signInWithCredential(credential).then((value) {
        UiRender.showSnackBar(
          context,
          'Đã đăng kí đơn hàng',
        );

        context.router.pop();
      });
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      UiRender.showSnackBar(context, e.toString());
    }
  }

  void _resendOtp() async {
    await FirebaseSmsService.verifyPhoneNumber(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.router.pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50.height),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Xác nhận OTP',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 20.size,
              ),
            ),
            10.verticalSpace,
            Text(
              'Vui lòng nhập mã OTP của bạn',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            10.verticalSpace,
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50.height,
              padding: EdgeInsets.all(7.size),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10.radius),
              ),
              child: TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            GradientElevatedButton(
              text: 'Xác thực',
              onPress: _onPressVerifyButton,
              beginColor: Theme.of(context).colorScheme.onError,
              endColor: Theme.of(context).colorScheme.onError,
            ),
            TextButton(
              onPressed: _resendOtp,
              child: Text(
                'Gửi lại',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
