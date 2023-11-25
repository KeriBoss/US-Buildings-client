import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/data/static/app_value.dart';
import 'package:us_building_client/services/loading_service.dart';
import 'package:us_building_client/utils/ui_render.dart';
import 'package:us_building_client/views/layout/layout.dart';
import 'package:us_building_client/views/widgets/service_lv2_bottom_dialog.dart';

import '../../bloc/service/service_bloc.dart';
import '../../data/models/service_model.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// for mockup
  List<ServiceModel> dummyServiceList = [
    ServiceModel(
        id: '2',
        iconUrl:
            'https://th.bing.com/th/id/R.0a78fb4770ab50e23189874319be5943?rik=DYcPdmgtY%2bmDTA&pid=ImgRaw&r=0',
        serviceLv1Name: 'service'),
    ServiceModel(
        id: '2',
        iconUrl:
            'https://th.bing.com/th/id/R.0a78fb4770ab50e23189874319be5943?rik=DYcPdmgtY%2bmDTA&pid=ImgRaw&r=0',
        serviceLv1Name: 'service'),
  ];

  ///

  void _selectServiceLv1(ServiceModel serviceModel) {
    context.read<ServiceBloc>().add(
          OnLoadServiceLv2ListEvent(serviceModel.serviceLv1Name!),
        );

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 1,
      enableDrag: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2,
        minHeight: MediaQuery.of(context).size.height / 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.radius),
          topRight: Radius.circular(20.radius),
        ),
      ),
      builder: (context) {
        return ServiceLv2BottomSheet(
          serviceLv1: serviceModel,
        );
      },
    );
  }

  @override
  void initState() {
    LoadingService(context).reloadHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: RefreshIndicator(
        onRefresh: LoadingService(context).reloadHomePage,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _banner(
                'https://icdn.dantri.com.vn/thumb_w/660/2021/06/09/chodocx-1623207689539.jpeg',
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.width, 0, 30.width, 7.height),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.radius),
                    bottomLeft: Radius.circular(30.radius),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        15.width,
                        10.height,
                        30.width,
                        15.height,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.verticalSpace,
                          Text(
                            'Tất cả dịch vụ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.size,
                            ),
                          ),
                          8.verticalSpace,
                          BlocBuilder<ServiceBloc, ServiceState>(
                            builder: (context, state) {
                              List<ServiceModel> serviceList =
                                  context.read<ServiceBloc>().serviceLv1List;

                              if (state is ServiceLv1ListLoadingState) {
                                return UiRender.loadingCircle(context);
                              } else if (state is ServiceLv1ListLoadedState) {
                                serviceList = state.serviceLv1List;
                              }

                              return _serviceList(serviceList);
                            },
                          ),
                        ],
                      ),
                    ),
                    _banner(
                      'https://www.baokontum.com.vn/uploads/Image/2023/01/09/103359ta-con-meo.jpg',
                    ),
                    10.verticalSpace,
                    GridView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: 13.height,
                      ),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 20.width,
                        mainAxisSpacing: 20.height,
                      ),
                      itemCount: dummyServiceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _otherService(
                          dummyServiceList[index].iconUrl!,
                          dummyServiceList[index].serviceLv1Name!,
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

  Widget _serviceList(List<ServiceModel> serviceList) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.width,
        vertical: 4.height,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 80.size,
          childAspectRatio: 1,
          crossAxisSpacing: 5.width,
          mainAxisSpacing: 5.height,
        ),
        itemCount: serviceList.length,
        itemBuilder: (context, index) {
          return _serviceListItem(serviceList[index]);
        },
      ),
    );
  }

  Widget _serviceListItem(ServiceModel service) {
    return GestureDetector(
      onTap: () => _selectServiceLv1(service),
      child: Column(
        children: [
          Container(
            height: 40.size,
            width: 40.size,
            padding: EdgeInsets.all(1.size),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
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
            service.serviceLv1Name ?? 'Undefined',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              fontSize: 13.size,
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherService(String url, String name) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.radius),
            child: UiRender.networkImage(
              url,
              height: 100.size,
              width: 100.size,
            ),
          ),
          Text(name),
        ],
      ),
    );
  }
}
