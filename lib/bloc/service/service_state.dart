part of 'service_bloc.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();
}

class ServiceInitial extends ServiceState {
  @override
  List<Object> get props => [];
}

class ServiceLoadingState extends ServiceState {
  @override
  List<Object?> get props => [];
}

class ServiceLv1ListLoadingState extends ServiceState {
  @override
  List<Object?> get props => [];
}

class ServiceLv2ListLoadingState extends ServiceState {
  @override
  List<Object?> get props => [];
}

class ServiceLv1ListLoadedState extends ServiceState {
  final List<ServiceModel> serviceLv1List;

  const ServiceLv1ListLoadedState(this.serviceLv1List);

  @override
  List<Object?> get props => [serviceLv1List];
}

class ServiceLv2ListLoadedState extends ServiceState {
  final List<ServiceModel> serviceLv2List;

  const ServiceLv2ListLoadedState(this.serviceLv2List);

  @override
  List<Object?> get props => [serviceLv2List];
}

class ServiceListLoadedState extends ServiceState {
  final List<ServiceModel> serviceList;

  const ServiceListLoadedState(this.serviceList);

  @override
  List<Object?> get props => [serviceList];
}

class ServiceOrderCreatedState extends ServiceState {
  final String message;

  const ServiceOrderCreatedState(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiceOrderListLoadedState extends ServiceState {
  final List<ServiceOrderModel> serviceOrderList;

  const ServiceOrderListLoadedState(this.serviceOrderList);

  @override
  List<Object?> get props => [serviceOrderList];
}

class ServiceErrorState extends ServiceState {
  final String message;

  const ServiceErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
