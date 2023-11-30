import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/repair_man_model.dart';
import '../../data/repositories/repair_man_repository.dart';

part 'repair_man_event.dart';
part 'repair_man_state.dart';

class RepairManBloc extends Bloc<RepairManEvent, RepairManState> {
  final RepairManRepository _repairManRepository;

  List<RepairManModel> repairMenList = [];

  RepairManBloc(this._repairManRepository) : super(RepairManInitial()) {
    on<OnLoadRepairMenListEvent>((event, emit) async {
      emit(RepairManLoadingState());

      try {
        final response = await _repairManRepository.getRepairMenList();

        response.fold(
          (failure) => emit(RepairManErrorState(failure.message)),
          (list) {
            repairMenList = List.of(list);

            emit(RepairMenListLoadedState(list));
          },
        );
      } catch (e, stackTrace) {
        debugPrint(
          'Caught ERROR: ${e.toString()} \n${stackTrace.toString()}',
        );
        emit(RepairManErrorState(e.toString()));
      }
    });
  }
}
