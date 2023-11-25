import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/service_model.dart';
import '../../data/repositories/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;

  List<ServiceModel> serviceLv1List = [];
  List<ServiceModel> serviceLv2List = [];

  ServiceBloc(this._serviceRepository) : super(ServiceInitial()) {
    on<OnLoadServiceLv1ListEvent>((event, emit) async {
      emit(ServiceLoadingState());

      try {
        final response = await _serviceRepository.getServiceLv1List();

        response.fold(
          (failure) => emit(ServiceErrorState(failure.message)),
          (list) {
            serviceLv1List = List.of(list);

            emit(ServiceLv1ListLoadedState(list));
          },
        );
      } catch (e, stackTrace) {
        debugPrint(
          'Caught ERROR: ${e.toString()} \n${stackTrace.toString()}',
        );

        emit(ServiceErrorState(e.toString()));
      }
    });
  }
}
