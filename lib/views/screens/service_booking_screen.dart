import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/core/extension/datetime_extension.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/core/extension/time_of_day_extension.dart';
import 'package:us_building_client/data/models/repair_man_model.dart';
import 'package:us_building_client/data/models/service_model.dart';
import 'package:us_building_client/data/models/service_order_model.dart';
import 'package:us_building_client/utils/ui_render.dart';
import 'package:us_building_client/views/screens/phone_otp_verification_screen.dart';
import 'package:us_building_client/views/widgets/gradient_button.dart';

import '../../bloc/google_map/google_map_bloc.dart';
import '../../bloc/repair_man/repair_man_bloc.dart';
import '../../bloc/service/service_bloc.dart';
import '../../services/firebase_sms_service.dart';

@RoutePage()
class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _requirementController = TextEditingController();
  final SingleValueDropDownController _repairManNameController =
      SingleValueDropDownController();

  final GlobalKey<FormState> serviceBookingFormKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _currentAddress = '';
  final int _overTimePoint = (17 * 60) + 30;
  final double _overtimePrice = 100000;

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

  final String? Function(String?) _phoneValidator = (String? value) {
    if (value!.length != 10) {
      return 'Số điện thoại phải bao gồm 10 số';
    }

    return null;
  };

  void _selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(2018),
      lastDate: DateTime(2050),
    );

    if (date != null && date != _selectedDate && date.isAfter(DateTime.now())) {
      setState(() {
        _selectedDate = date;
      });
    } else {
      UiRender.showDialog(context, '', 'Vui lòng chọn lại ngày');
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
    if (_currentAddress.isEmpty) {
      UiRender.showSnackBar(context, 'Bạn chưa điền địa chỉ');
      return;
    }

    if (serviceBookingFormKey.currentState!.validate()) {
      FirebaseSmsService.verifyPhoneNumber(_phoneController.text);

      ServiceModel currentService =
          context.read<ServiceBloc>().currentSelectedService!;

      double totalPrice = _selectedTime.toMinutes >= _overTimePoint
          ? double.parse(currentService.price!) + _overtimePrice
          : double.parse(currentService.price!);

      ServiceOrderModel newServiceOrder = ServiceOrderModel(
        createdDate: DateTime.now().dateTimeApiFormat,
        clientFullName: _nameController.text,
        clientPhoneNumber: _phoneController.text,
        serviceName: currentService.serviceName,
        bookingTime:
            '${_selectedDate.dateApiFormat}T${_selectedTime.hour}:${_selectedTime.minute}',
        price: currentService.price,
        totalPrice: totalPrice.format,
        clientRequest: _requirementController.text,
        repairManName: _repairManNameController.dropDownValue?.value,
        currentLocation: _currentAddress,
      );

      context.router.pushWidget(PhoneOtpVerificationScreen(
        phoneNumber: _phoneController.text,
        newServiceOrder: newServiceOrder,
      ));
    } else {
      UiRender.showSnackBar(context, 'Kiểm tra lại các thông tin bạn vừa nhập');
    }
  }

  Future<void> _selectLocation() async {
    context.read<GoogleMapBloc>().add(OnLoadCurrentAddressEvent());

    // context.router.pushNamed(AppRouterPath.map);
  }

  @override
  void initState() {
    context.read<RepairManBloc>().add(OnLoadRepairMenListEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceBloc, ServiceState>(
      listener: (context, state) {
        if (state is ServiceOrderCreatedState) {
          UiRender.showDialog(context, '', state.message);
        } else if (state is ServiceErrorState) {
          UiRender.showDialog(context, '', state.message);
        }
      },
      child: SingleChildScrollView(
        child: Form(
          key: serviceBookingFormKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.width),
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
                    child: BlocConsumer<GoogleMapBloc, GoogleMapState>(
                      listener: (context, state) {
                        if (state is GoogleMapCurrentAddressErrorState) {
                          UiRender.showDialog(context, '', state.message);
                        } else if (state
                            is GoogleMapCurrentAddressLoadedState) {
                          setState(() {
                            _currentAddress = state.address;
                          });
                        }
                      },
                      builder: (context, state) {
                        String? currentAddress =
                            context.read<GoogleMapBloc>().currentAddress;

                        if (state is GoogleMapLoadingState) {
                          return UiRender.loadingCircle(context);
                        } else if (state
                            is GoogleMapCurrentAddressLoadedState) {
                          currentAddress = state.address;
                        }

                        return currentAddress == null || currentAddress.isEmpty
                            ? Column(
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
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
                                    buttonMargin:
                                        EdgeInsets.only(top: 5.height),
                                    beginColor:
                                        Theme.of(context).colorScheme.onError,
                                    endColor:
                                        Theme.of(context).colorScheme.onError,
                                    buttonHeight: 50.height,
                                    buttonWidth: 240.width,
                                    borderRadiusIndex: 15.radius,
                                    onPress: _selectLocation,
                                  ),
                                ],
                              )
                            : Text(
                                'Địa chỉ hiện tại: $currentAddress',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              );
                      },
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
                  additionalValidator: _phoneValidator,
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
                      child:
                          _timeSchedule(title: 'Ngày đặt lịch', isDate: true),
                    ),
                    15.horizontalSpace,
                    Expanded(
                      child:
                          _timeSchedule(title: 'Ngày đặt lịch', isDate: false),
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
                              _selectedTime.toMinutes >= _overTimePoint
                                  ? '${_overtimePrice.format} VND'
                                  : 'Không phụ thu',
                              style: TextStyle(
                                fontSize: 13.size,
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            _selectedTime.toMinutes >= _overTimePoint
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
                    controller: _requirementController,
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
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    Icon? leadingIcon,
    TextInputType? keyboardType,
    String? Function(String?)? additionalValidator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => _textFieldValidator(
        value,
        additionalValidator,
      ),
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
    return BlocBuilder<RepairManBloc, RepairManState>(
      builder: (context, state) {
        List<RepairManModel> repairMenList =
            context.read<RepairManBloc>().repairMenList;

        if (state is RepairManLoadingState) {
          return UiRender.loadingCircle(context);
        } else if (state is RepairMenListLoadedState) {
          repairMenList = state.repairMenList;
        }

        return Container(
          padding: EdgeInsets.all(7.size),
          child: DropDownTextField(
            controller: _repairManNameController,
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
            dropDownList: List.generate(
              repairMenList.length,
              (index) => DropDownValueModel(
                name: repairMenList[index].name!,
                value: repairMenList[index].name!,
              ),
            ),
          ),
        );
      },
    );
  }
}
