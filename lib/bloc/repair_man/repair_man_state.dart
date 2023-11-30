part of 'repair_man_bloc.dart';

abstract class RepairManState extends Equatable {
  const RepairManState();
}

class RepairManInitial extends RepairManState {
  @override
  List<Object> get props => [];
}

class RepairManLoadingState extends RepairManState {
  @override
  List<Object?> get props => [];
}

class RepairMenListLoadedState extends RepairManState {
  final List<RepairManModel> repairMenList;

  const RepairMenListLoadedState(this.repairMenList);

  @override
  List<Object?> get props => [];
}

class RepairManErrorState extends RepairManState {
  final String message;

  const RepairManErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
