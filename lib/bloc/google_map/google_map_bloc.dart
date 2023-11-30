import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:us_building_client/core/extension/latLng_extension.dart';
import 'package:us_building_client/core/extension/pointLatLng_extension.dart';
import 'package:us_building_client/core/extension/position_extension.dart';

import '../../data/repositories/google_map_repository.dart';
import '../../services/google_map_service.dart';

part 'google_map_event.dart';
part 'google_map_state.dart';

class GoogleMapBloc extends Bloc<GoogleMapEvent, GoogleMapState> {
  final GoogleMapRepository _googleMapRepository;
  String? selectedPhoneTokenFromMessage;
  List<Prediction> predictionList = [];
  double distance = 0;

  String? currentAddress;

  /// for product
  Prediction currentSelectedPrediction =
      Prediction(description: 'Tìm kiếm địa chỉ...');
  PointLatLng? currentPointLatLng;

  /// for test
  PointLatLng testPoint =
      const PointLatLng(10.868814409965742, 106.65022524592496);

  GoogleMapBloc(this._googleMapRepository) : super(GoogleMapInitial()) {
    on<OnLoadPredictionsEvent>((event, emit) async {
      emit(GoogleMapLoadingState());

      try {
        final response = await _googleMapRepository.getLocationData(event.text);

        response.fold(
          (failure) => emit(GoogleMapSearchingErrorState(failure.message)),
          (data) {
            predictionList = data;

            emit(GoogleMapLoadedState(data));
          },
        );
      } catch (e, stackTrace) {
        debugPrint('Catch error: ${e.toString()} \n ${stackTrace.toString()}');
        emit(GoogleMapSearchingErrorState(e.toString()));
      }
    });

    on<OnLoadNewLocationEvent>((event, emit) async {
      emit(GoogleMapLoadingState());

      try {
        /// for production
        final response = await _googleMapRepository.getDetailsByPlaceId(
          event.prediction.placeId!,
        );

        response.fold(
          (failure) {
            if (failure.message.contains(
                'type \'Null\' is not a subtype of type \'Map<String, dynamic>\' in type cast')) {
              /// for test
              currentPointLatLng = testPoint;
              currentSelectedPrediction = event.prediction;

              emit(GoogleMapNewLocationLoadedState(
                testPoint.toLatLng,
                event.prediction,
              ));
            } else {
              debugPrint(
                'Catch error: ${failure.message}',
              );
              emit(GoogleMapErrorState(failure.message));
            }
          },
          (details) {
            if (details.isOkay) {
              final location = details.result.geometry?.location;
              final latLng = LatLng(
                location!.lat,
                location.lng,
              );

              currentSelectedPrediction = event.prediction;
              currentPointLatLng = PointLatLng(
                location.lat,
                location.lng,
              );

              emit(GoogleMapNewLocationLoadedState(
                latLng,
                event.prediction,
              ));
            } else {
              emit(GoogleMapErrorState(details.result.name));
            }
          },
        );
      } catch (e, stackTrace) {
        if (e.toString().contains(
            'type \'Null\' is not a subtype of type \'Map<String, dynamic>\' in type cast')) {
          /// for test
          currentPointLatLng = testPoint;
          currentSelectedPrediction = event.prediction;

          emit(GoogleMapNewLocationLoadedState(
            testPoint.toLatLng,
            event.prediction,
          ));
        } else {
          debugPrint(
            'Catch error: ${e.toString()} \n ${stackTrace.toString()}',
          );
          emit(GoogleMapErrorState(e.toString()));
        }
      }
    });

    on<OnClearLocationEvent>((event, emit) {
      currentSelectedPrediction =
          Prediction(description: 'Tìm kiếm địa chỉ...');
      currentPointLatLng = null;
      distance = 0;

      emit(const GoogleMapLocationClearedState());
    });

    on<OnCalculateDistanceEvent>((event, emit) {
      emit(GoogleMapLoadingState());

      distance = Geolocator.distanceBetween(
            event.startLatLng.latitude,
            event.startLatLng.longitude,
            event.endLatLng.latitude,
            event.endLatLng.longitude,
          ) /
          1000;

      emit(GoogleMapDistanceCalculatedState(distance));
    });

    on<OnLoadCurrentLocationEvent>((event, emit) async {
      emit(GoogleMapLoadingState());

      try {
        await Geolocator.requestPermission()
            .then((value) {})
            .onError((error, stackTrace) async {
          await Geolocator.requestPermission();
          debugPrint("ERROR: $error");
        });

        final Position pos = await Geolocator.getCurrentPosition();

        currentPointLatLng = pos.toPointLatLng;

        if (currentPointLatLng != null) {
          GoogleMapCurrentLocationLoadedState(
            currentPointLatLng!.toLatLng,
          );
        } else {
          emit(const GoogleMapErrorState(
            'Không thể lấy địa điểm hiện tại của bạn, hãy kiểm tra xem bạn đã kết nối mạng, mở truy cập định vị chưa và đã cho phép ứng dụng quyền truy cập vị trí chưa',
          ));
        }
      } catch (e, stackTrace) {
        debugPrint('Catch error: ${e.toString()} \n ${stackTrace.toString()}');
        emit(GoogleMapErrorState(e.toString()));
      }
    });

    on<OnLoadDefaultLocationEvent>((event, emit) async {
      List<Placemark> addresses = await placemarkFromCoordinates(
        event.currentLatLng.latitude,
        event.currentLatLng.longitude,
      );

      String currentAddress =
          '${addresses.first.street}, ${addresses.first.subAdministrativeArea}, ${addresses.first.administrativeArea}, ${addresses.first.country}';

      currentSelectedPrediction = Prediction(
        description: currentAddress,
      );
      currentPointLatLng = event.currentLatLng.toPointLatLng;

      currentPointLatLng = event.currentLatLng.toPointLatLng;

      emit(GoogleMapNewLocationLoadedState(
        event.currentLatLng,
        Prediction(description: currentAddress),
      ));
    });

    on<OnClearMapEvent>((event, emit) {
      selectedPhoneTokenFromMessage;
      predictionList.clear();
      distance = 0;
      currentSelectedPrediction =
          Prediction(description: 'Tìm kiếm địa chỉ...');
      currentPointLatLng = null;
    });

    on<OnLoadCurrentAddressEvent>((event, emit) async {
      emit(GoogleMapLoadingState());

      try {
        await Geolocator.requestPermission()
            .then((value) {})
            .onError((error, stackTrace) async {
          await Geolocator.requestPermission();
          debugPrint("ERROR: $error");
        });

        final Position pos = await Geolocator.getCurrentPosition();

        String? currentAddress = await GoogleMapService.getAddressFromLocation(
          pos.latitude,
          pos.longitude,
        );

        if (currentAddress != null && currentAddress.isNotEmpty) {
          emit(GoogleMapCurrentAddressLoadedState(currentAddress));
        } else {
          emit(const GoogleMapCurrentAddressLoadedState(
            'Không thể tìm thấy vị trí của bạn',
          ));
        }
      } catch (e, stackTrace) {
        debugPrint('Catch error: ${e.toString()} \n ${stackTrace.toString()}');
        emit(GoogleMapErrorState(e.toString()));
      }
    });
  }
}
