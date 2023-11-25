part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadServiceLv1ListEvent extends ServiceEvent {}

class OnLoadServiceLv2ListEvent extends ServiceEvent {
  final String serviceLv1Name;

  const OnLoadServiceLv2ListEvent(this.serviceLv1Name);
}

class OnLoadServiceListEvent extends ServiceEvent {
  final String serviceLv2Name;

  const OnLoadServiceListEvent(this.serviceLv2Name);
}
