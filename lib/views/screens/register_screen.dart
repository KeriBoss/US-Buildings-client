import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/core/router/app_router_config.dart';
import 'package:us_building_client/views/widgets/gradient_button.dart';

import '../../bloc/authorization/authorization_bloc.dart';
import '../../data/models/user.dart';
import '../../data/static/enum/local_storage_enum.dart';
import '../../data/static/enum/password_textfile_type_enum.dart';
import '../../services/local_storage_service.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();

  bool _isPasswordObscure = true;
  bool _isCfmPasswordObscure = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onPressBackButton() {
    context.router.pop();
  }

  String? _textFieldValidator(
    String? value,
    String? Function(String?)? additionalValidator,
  ) {
    if (value == null || value.isEmpty) {
      return 'Không được để trống!';
    } else if (additionalValidator != null) {
      return additionalValidator(value);
    }
    return null;
  }

  void _onPressPasswordEyeButton() {
    setState(() {
      _isPasswordObscure = !_isPasswordObscure;
    });
  }

  void _onPressCfmPasswordEyeButton() {
    setState(() {
      _isCfmPasswordObscure = !_isCfmPasswordObscure;
    });
  }

  final String? Function(String?) _passwordValidator = (String? value) {
    if (value!.trim().contains(' ')) {
      return 'Mật khẩu không được phép có khoảng trống';
    }

    return null;
  };

  final String? Function(String?) _sexValidator = (String? value) {
    if (value == null || value.isEmpty || value.trim().contains(' ')) {
      return 'Cần phải chọn giới tính';
    }

    return null;
  };

  final String? Function(String?) _phoneValidator = (String? value) {
    if (value!.length != 10) {
      return 'Số điện thoại phải bao gồm 10 số';
    }

    return null;
  };

  final String? Function(String?) _idCertNumValidator = (String? value) {
    if (value!.length != 12) {
      return 'Số CCCD/CMT phải bao gồm 12 số';
    }

    return null;
  };

  void _onPressedRegisterButton() async {
    // if (_passwordTextEditingController.text !=
    //     _confirmPasswordTextEditingController.text) {
    //   UiRender.showSnackBar(
    //     context,
    //     'Password field must match Confirm password field',
    //   );
    // }

    if (_formKey.currentState!.validate()) {
      // FirebaseSmsService.verifyPhoneNumber(
      //   _phoneNumberTextEditingController.text,
      // );

      String fcmToken = await LocalStorageService.getLocalStorageData(
        LocalStorageEnum.phoneToken.name,
      ) as String;

      User newUser = User(
        password: _passwordTextEditingController.text,
        phoneNumber: _phoneNumberTextEditingController.text,
        phoneFcmToken: fcmToken,
      );

      // context.router.pushWidget(
      //   PhoneVerificationScreen(
      //     user: newUser,
      //     purpose: PhoneVerifyPurposeEnum.register,
      //   ),
      // );

      //   User newUser = User(
      //     fullName: _fullNameTextEditingController.text,
      //     password: _passwordTextEditingController.text,
      //     phoneNumber: _phoneNumberTextEditingController.text,
      //     phoneFcmToken: fcmToken,
      //     userRole: widget.isShipper ? 'shipper' : 'client',
      //     address: _addressTextEditingController.text,
      //     idCertificateNumber: _idCertNumTextEditingController.text,
      //     sex: _sexDropdownController.dropDownValue?.value,
      //   );
      //
      context.read<AuthorizationBloc>().add(
            OnRegisterEvent(newUser),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.router.pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Tạo tài khoản',
          style: TextStyle(
            fontSize: 17.size,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(20.size),
          color: Colors.white,
          child: BlocListener<AuthorizationBloc, AuthorizationState>(
            listener: (context, state) {
              if (state is AuthorizationRegisteredState) {
                context.router.replaceAll([const HomeRoute()]);
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nhập thông tin tài khoản',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.size,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  25.verticalSpace,
                  _customTextField(
                    controller: _phoneNumberTextEditingController,
                    hintText: 'Số điện thoại (*)',
                    keyboardType: TextInputType.number,
                    additionalValidator: _phoneValidator,
                  ),
                  _customTextField(
                    controller: _passwordTextEditingController,
                    hintText: 'Mật khẩu',
                    isPassword: true,
                    isObscure: _isPasswordObscure,
                    type: PasswordTextFieldType.password,
                    additionalValidator: _passwordValidator,
                  ),
                  GradientElevatedButton(
                    text: 'Tạo tài khoản',
                    buttonHeight: 50.height,
                    onPress: _onPressedRegisterButton,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isObscure = false,
    String? Function(String?)? additionalValidator,
    PasswordTextFieldType? type,
  }) {
    return Container(
      padding: const EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(vertical: 15.height),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 5.width),
              ),
              validator: (value) => _textFieldValidator(
                value,
                additionalValidator,
              ),
              obscureText: isObscure,
            ),
          ),
          !isPassword
              ? const SizedBox()
              : IconButton(
                  onPressed: type == PasswordTextFieldType.password
                      ? _onPressPasswordEyeButton
                      : _onPressCfmPasswordEyeButton,
                  icon: Icon(
                    isObscure
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ],
      ),
    );
  }
}
