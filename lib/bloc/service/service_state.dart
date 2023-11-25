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

class ServiceErrorState extends ServiceState {
  final String message;

  const ServiceErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
