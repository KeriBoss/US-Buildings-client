part of 'google_map_bloc.dart';

abstract class GoogleMapState extends Equatable {
  const GoogleMapState();
}

class GoogleMapInitial extends GoogleMapState {
  @override
  List<Object> get props => [];
}

class GoogleMapSelectedState extends GoogleMapState {
  final Prediction? prediction;
  final bool isFromLocation;

  const GoogleMapSelectedState(
    this.prediction,
    this.isFromLocation,
  );

  @override
  List<Object?> get props => [prediction, isFromLocation];
}

class GoogleMapNewLocationLoadedState extends GoogleMapState {
  final LatLng latLng;
  final Prediction? prediction;

  const GoogleMapNewLocationLoadedState(
    this.latLng,
    this.prediction,
  );

  @override
  List<Object?> get props => [latLng, prediction];
}

class GoogleMapLoadedState extends GoogleMapState {
  final List<Prediction> predictionList;

  const GoogleMapLoadedState(this.predictionList);

  @override
  List<Object?> get props => [predictionList];
}

class GoogleMapLoadingState extends GoogleMapState {
  @override
  List<Object?> get props => [];
}

class GoogleMapLocationClearedState extends GoogleMapState {
  const GoogleMapLocationClearedState();

  @override
  List<Object?> get props => [];
}

class GoogleMapDefaultLocationLoadedState extends GoogleMapState {
  const GoogleMapDefaultLocationLoadedState();

  @override
  List<Object?> get props => [];
}

class GoogleMapErrorState extends GoogleMapState {
  final String message;

  const GoogleMapErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GoogleMapSearchingErrorState extends GoogleMapState {
  final String message;

  const GoogleMapSearchingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GoogleMapCurrentAddressLoadedState extends GoogleMapState {
  final String address;

  const GoogleMapCurrentAddressLoadedState(this.address);

  @override
  List<Object?> get props => [address];
}

class GoogleMapCurrentAddressErrorState extends GoogleMapState {
  final String message;

  const GoogleMapCurrentAddressErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GoogleMapDistanceCalculatedState extends GoogleMapState {
  final double distance;

  const GoogleMapDistanceCalculatedState(this.distance);

  @override
  List<Object?> get props => [distance];
}

class GoogleMapCurrentLocationLoadedState extends GoogleMapState {
  final LatLng currentLatLng;

  const GoogleMapCurrentLocationLoadedState(this.currentLatLng);

  @override
  List<Object?> get props => [currentLatLng];
}
