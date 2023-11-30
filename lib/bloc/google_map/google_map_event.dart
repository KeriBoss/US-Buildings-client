part of 'google_map_bloc.dart';

abstract class GoogleMapEvent extends Equatable {
  GoogleMapEvent();

  @override
  List<Object?> props = [];
}

class OnLoadPredictionsEvent extends GoogleMapEvent {
  final String text;

  OnLoadPredictionsEvent(this.text);
}

class OnClearLocationEvent extends GoogleMapEvent {
  OnClearLocationEvent();
}

class OnLoadDefaultLocationEvent extends GoogleMapEvent {
  final LatLng currentLatLng;

  OnLoadDefaultLocationEvent(this.currentLatLng);
}

class OnLoadNewLocationEvent extends GoogleMapEvent {
  final Prediction prediction;

  OnLoadNewLocationEvent(this.prediction);
}

class OnCalculateDistanceEvent extends GoogleMapEvent {
  final LatLng startLatLng;
  final LatLng endLatLng;

  OnCalculateDistanceEvent(this.startLatLng, this.endLatLng);
}

class OnLoadCurrentLocationEvent extends GoogleMapEvent {
  final String phoneNumber;

  OnLoadCurrentLocationEvent(this.phoneNumber);
}

class OnLoadCurrentAddressEvent extends GoogleMapEvent {}

class OnClearMapEvent extends GoogleMapEvent {}
