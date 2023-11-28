import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/core/extension/datetime_extension.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/services/firebase_sms_service.dart';
import 'package:us_building_client/utils/ui_render.dart';
import 'package:us_building_client/views/screens/phone_otp_verification_screen.dart';
import 'package:us_building_client/views/widgets/gradient_button.dart';

@RoutePage()
class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final SingleValueDropDownController _workerNameController =
      SingleValueDropDownController();

  final GlobalKey<FormState> serviceBookingFormKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final double _overtimePrice = 100000;

  void _selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(2018),
      lastDate: DateTime(2050),
    );

    if (date != null && date != _selectedDate) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null && time != _selectedTime) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _bookService() {
    if (_phoneController.text.isNotEmpty &&
        _phoneController.text.length == 10) {
      FirebaseSmsService.verifyPhoneNumber(_phoneController.text);

      context.router.pushWidget(PhoneOtpVerificationScreen(
        phoneNumber: _phoneController.text,
      ));
    } else {
      UiRender.showSnackBar(context, 'Nhập lại số điện thoại');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: serviceBookingFormKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.width),
          padding: EdgeInsets.symmetric(
            vertical: 35.height,
            horizontal: 15.width,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.radius),
              bottomRight: Radius.circular(30.radius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  10.horizontalSpace,
                  Text(
                    'THÔNG TIN LIÊN HỆ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
              5.verticalSpace,
              DottedBorder(
                dashPattern: [20, 20],
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onSecondary,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.height,
                    horizontal: 20.width,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Bạn chưa có địa chỉ trong danh sách hệ thống',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GradientElevatedButton(
                        text: '+ THÊM ĐỊA CHỈ',
                        textSize: 20.size,
                        textWeight: FontWeight.w500,
                        textFontStyle: FontStyle.italic,
                        buttonMargin: EdgeInsets.only(top: 5.height),
                        beginColor: Theme.of(context).colorScheme.onError,
                        endColor: Theme.of(context).colorScheme.onError,
                        buttonHeight: 50.height,
                        buttonWidth: 240.width,
                        borderRadiusIndex: 15.radius,
                        onPress: () {},
                      ),
                    ],
                  ),
                ),
              ),
              _customTextField(
                controller: _nameController,
                label: 'Họ và tên',
                leadingIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              _customTextField(
                controller: _phoneController,
                label: 'Số điện thoại',
                keyboardType: TextInputType.phone,
                leadingIcon: Icon(
                  Icons.phone,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _timeSchedule(title: 'Ngày đặt lịch', isDate: true),
                  ),
                  15.horizontalSpace,
                  Expanded(
                    child: _timeSchedule(title: 'Ngày đặt lịch', isDate: false),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _dropdownTextField(),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.height),
                      padding: EdgeInsets.all(10.size),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(25.radius),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _selectedTime.hour > 17 && _selectedTime.minute > 30
                                ? '${_overtimePrice.format} VND'
                                : 'Không phụ thu',
                            style: TextStyle(
                              fontSize: 13.size,
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          _selectedTime.hour > 17 && _selectedTime.minute > 30
                              ? Text(
                                  'Auto',
                                  style: TextStyle(
                                    fontSize: 13.size,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 100.height,
                padding: EdgeInsets.all(8.size),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15.radius),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Nhập yêu cầu của bạn...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              10.verticalSpace,
              Row(
                children: [
                  15.horizontalSpace,
                  Text(
                    'Thông tin bắt buộc',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              GradientElevatedButton(
                text: 'ĐẶT LỊCH NGAY',
                buttonMargin: EdgeInsets.zero,
                buttonHeight: 43.height,
                beginColor: Theme.of(context).colorScheme.primary,
                endColor: Theme.of(context).colorScheme.primary,
                borderRadiusIndex: 8.radius,
                onPress: _bookService,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    Icon? leadingIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5.height),
        icon: leadingIcon,
        hintText: 'Nhập ${label.toLowerCase()}...',
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.size,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.size,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeSchedule({
    required String title,
    required bool isDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
        isDate
            ? GestureDetector(
                onTap: _selectDate,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.height),
                  padding: EdgeInsets.all(10.size),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.radius),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      5.horizontalSpace,
                      Text(_selectedDate.date),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: _selectTime,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.height),
                  padding: EdgeInsets.all(10.size),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(25.radius),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      8.horizontalSpace,
                      Text(
                        '${_selectedTime.hour}:${_selectedTime.minute} ${_selectedTime.period.name.toUpperCase()}',
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _dropdownTextField() {
    return Container(
      padding: EdgeInsets.all(7.size),
      child: DropDownTextField(
        controller: _workerNameController,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 13.size,
        ),
        textFieldDecoration: InputDecoration(
          hintText: "Chọn thợ",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 13.size,
          ),
        ),
        clearOption: true,
        dropDownItemCount: 3,
        dropDownList: const [
          DropDownValueModel(name: 'Hoàng Vinh', value: "male"),
          DropDownValueModel(name: 'Đoàn Phát', value: "female"),
          DropDownValueModel(name: 'Phi Lâm', value: "other"),
        ],
      ),
    );
  }
}
