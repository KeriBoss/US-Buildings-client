import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:us_building_client/data/static/enum/database_table_enum.dart';

import '../../data/models/service_model.dart';
import '../../data/repositories/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;

  List<ServiceModel> serviceLv1List = [];
  List<ServiceModel> serviceLv2List = [];
  List<ServiceModel> serviceList = [];

  ServiceBloc(this._serviceRepository) : super(ServiceInitial()) {
    on<OnLoadServiceLv1ListEvent>((event, emit) async {
      emit(ServiceLv1ListLoadingState());

      try {
        final response = await _serviceRepository.getServiceModelList(
          DatabaseTableEnum.tbl_com_01_us_01_dvcap1,
        );

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

    on<OnLoadServiceLv2ListEvent>((event, emit) async {
      emit(ServiceLv2ListLoadingState());

      try {
        final response = await _serviceRepository.getServiceModelList(
            DatabaseTableEnum.tbl_com_01_us_02_dvcap2,
            queryMap: {
              'fieldname': 'tendichvucap1',
              'fieldvalue': event.serviceLv1Name,
            });

        response.fold(
          (failure) => emit(ServiceErrorState(failure.message)),
          (list) {
            serviceLv2List = List.of(list);

            emit(ServiceLv2ListLoadedState(list));
          },
        );
      } catch (e, stackTrace) {
        debugPrint(
          'Caught ERROR: ${e.toString()} \n${stackTrace.toString()}',
        );
        emit(ServiceErrorState(e.toString()));
      }
    });

    on<OnLoadServiceListEvent>((event, emit) async {
      emit(ServiceLoadingState());

      try {
        final response = await _serviceRepository.getServiceModelList(
            DatabaseTableEnum.tbl_com_01_us_03_taodichvu,
            queryMap: {
              'fieldname': 'tendichvucap2',
              'fieldvalue': event.serviceLv2Name,
            });

        response.fold(
          (failure) => emit(ServiceErrorState(failure.message)),
          (list) {
            serviceList = List.of(list);

            emit(ServiceListLoadedState(list));
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
