import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/bloc/service/service_bloc.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/utils/ui_render.dart';
import 'package:us_building_client/views/screens/service_list_screen.dart';

import '../../data/models/service_model.dart';
import '../../data/static/app_value.dart';

class ServiceLv2BottomSheet extends StatefulWidget {
  const ServiceLv2BottomSheet({
    super.key,
    required this.serviceLv1,
  });

  final ServiceModel serviceLv1;

  @override
  State<StatefulWidget> createState() => _ServiceLv2BottomSheetState();
}

class _ServiceLv2BottomSheetState extends State<ServiceLv2BottomSheet> {
  void _selectServiceLv2(ServiceModel serviceLv2) {
    context.router.pushWidget(ServiceListScreen(serviceLv2: serviceLv2));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10.width, 20.height, 10.width, 30.height),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DỊCH VỤ ${widget.serviceLv1.serviceLv1Name!.toUpperCase()}',
              style: TextStyle(
                fontSize: 20.size,
                fontWeight: FontWeight.w600,
              ),
            ),
            10.verticalSpace,
            BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                List<ServiceModel> serviceList =
                    context.read<ServiceBloc>().serviceLv2List;

                if (state is ServiceLv2ListLoadingState) {
                  return UiRender.loadingCircle(
                    context,
                    color: Theme.of(context).colorScheme.secondary,
                  );
                } else if (state is ServiceLv2ListLoadedState) {
                  serviceList = state.serviceLv2List;
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: 13.height,
                  ),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20.width,
                    mainAxisSpacing: 20.height,
                  ),
                  itemCount: serviceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _serviceListItem(serviceList[index]);
                  },
                );
              },
            ),
            5.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(5.size),
                    margin: EdgeInsets.only(right: 20.width),
                    height: 35.height,
                    width: 50.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.radius),
                      color: Theme.of(context).colorScheme.secondary,
                      image: const DecorationImage(
                        image: AssetImage('assets/icons/dots.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceListItem(ServiceModel service) {
    return GestureDetector(
      onTap: () => _selectServiceLv2(service),
      child: Column(
        children: [
          Container(
            height: 55.size,
            width: 55.size,
            padding: EdgeInsets.all(10.size),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: UiRender.networkImage(
                AppValue.commonImgUrl + service.iconUrl!,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            service.serviceLv2Name ?? 'Undefined',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 15.size,
            ),
          ),
        ],
      ),
    );
  }
}
