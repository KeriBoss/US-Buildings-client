part of 'repair_man_bloc.dart';

abstract class RepairManEvent extends Equatable {
  const RepairManEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnLoadRepairMenListEvent extends RepairManEvent {}
