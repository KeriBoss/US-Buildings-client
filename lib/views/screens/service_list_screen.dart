import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/bloc/service/service_bloc.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/data/models/service_model.dart';
import 'package:us_building_client/services/loading_service.dart';
import 'package:us_building_client/views/layout/layout.dart';
import 'package:us_building_client/views/widgets/service_list_item.dart';

import '../../utils/ui_render.dart';

@RoutePage()
class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key, required this.serviceLv2});

  final ServiceModel serviceLv2;

  @override
  State<StatefulWidget> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  void initState() {
    LoadingService(context).reloadServiceListPage(
      widget.serviceLv2.serviceLv2Name!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      canBack: true,
      body: RefreshIndicator(
        onRefresh: () => LoadingService(context).reloadServiceListPage(
          widget.serviceLv2.serviceLv2Name!,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _banner(
                'https://icdn.dantri.com.vn/thumb_w/660/2021/06/09/chodocx-1623207689539.jpeg',
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.width, 0, 30.width, 30.height),
                padding: EdgeInsets.fromLTRB(10.width, 0, 10.width, 7.height),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.radius),
                    bottomRight: Radius.circular(25.radius),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.width,
                        vertical: 12.height,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.radius),
                          bottomRight: Radius.circular(10.radius),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 5),
                            spreadRadius: 4,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        'BẢNG GIÁ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.size,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    BlocBuilder<ServiceBloc, ServiceState>(
                      builder: (context, state) {
                        List<ServiceModel> serviceList =
                            context.read<ServiceBloc>().serviceList;

                        if (state is ServiceLoadingState) {
                          return UiRender.loadingCircle(context);
                        } else if (state is ServiceListLoadedState) {
                          serviceList = state.serviceList;
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: serviceList.length,
                          itemBuilder: (context, index) {
                            return ServiceListItem(service: serviceList[index]);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _banner(String url) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: UiRender.networkImage(url),
    );
  }
}
