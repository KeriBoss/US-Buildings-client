import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/bloc/service/service_bloc.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/core/extension/string%20_extension.dart';
import 'package:us_building_client/data/models/service_order_model.dart';
import 'package:us_building_client/utils/ui_render.dart';

@RoutePage()
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    context.read<ServiceBloc>().add(OnLoadServiceOrderListEvent('0977815809'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.width),
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
          40.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10.height,
              horizontal: 20.width,
            ),
            child: Text(
              'Đơn hàng của bạn',
              style: TextStyle(
                fontSize: 14.size,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          BlocConsumer<ServiceBloc, ServiceState>(
            listener: (context, state) {},
            builder: (context, state) {
              List<ServiceOrderModel> serviceOrderList =
                  context.read<ServiceBloc>().serviceOrderList;

              if (state is ServiceLoadingState) {
                return UiRender.loadingCircle(context);
              } else if (state is ServiceOrderListLoadedState) {
                serviceOrderList = state.serviceOrderList;
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: serviceOrderList.length,
                itemBuilder: (context, index) {
                  return _serviceOrderListItem(serviceOrderList[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _serviceOrderListItem(ServiceOrderModel serviceOrder) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.width,
            vertical: 10.height,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.size,
                width: 50.size,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/repairman.png'),
                  ),
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${serviceOrder.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.size,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      serviceOrder.serviceName ?? 'Không xác định',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.size,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Text(
                      serviceOrder.bookingTime!.formatDateStringFromApi,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.size,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  serviceOrder.orderStatus!.toUpperCase(),
                  softWrap: true,
                  maxLines: 3,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.size,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.width),
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
          40.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10.height,
              horizontal: 20.width,
            ),
            child: Text(
              'Đơn hàng của bạn',
              style: TextStyle(
                fontSize: 14.size,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          BlocConsumer<ServiceBloc, ServiceState>(
            listener: (context, state) {},
            builder: (context, state) {
              List<ServiceOrderModel> serviceOrderList =
                  context.read<ServiceBloc>().serviceOrderList;

              if (state is ServiceLoadingState) {
                return UiRender.loadingCircle(context);
              } else if (state is ServiceOrderListLoadedState) {
                serviceOrderList = state.serviceOrderList;
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: serviceOrderList.length,
                itemBuilder: (context, index) {
                  return _serviceOrderListItem(serviceOrderList[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _serviceOrderListItem(ServiceOrderModel serviceOrder) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.width,
            vertical: 10.height,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55.size,
                width: 55.size,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/repairman.png'),
                  ),
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${serviceOrder.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.size,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      serviceOrder.serviceName ?? 'Không xác định',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.size,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Text(
                      serviceOrder.bookingTime!.formatDateStringFromApi,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.size,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  serviceOrder.orderStatus!.toUpperCase(),
                  softWrap: true,
                  maxLines: 3,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.size,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
