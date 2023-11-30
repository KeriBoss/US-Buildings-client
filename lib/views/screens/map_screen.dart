import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    as flutter_polyline_points;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/core/router/app_router_path.dart';

import '../../bloc/google_map/google_map_bloc.dart';
import '../../main.dart';
import '../widgets/gradient_button.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markerList = [];

  List<LatLng> polylineLatLngList = [];
  final PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylinesMap = {};
  late LatLng currentLatLng;

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      debugPrint("ERROR: $error");
    });

    return await Geolocator.getCurrentPosition();
  }

  void _clearAllMarkers() {
    setState(() {
      _markerList.clear();
    });
  }

  void _clearMarker(bool isFromLocation) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        setState(() {
          _markerList.removeWhere(
            (marker) => isFromLocation
                ? marker.markerId.value == 'From Location'
                : marker.markerId.value == 'To Location',
          );

          polylineLatLngList = [];
          polylinesMap = {};
        });
      },
    );
  }

  void _onPressTextBox() {
    context.router.pushNamed(AppRouterPath.searching);
  }

  void _onPressRemoveLocationButton() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        // context.read<GoogleMapBloc>().add(
        //   OnClearLocationEvent(isFromLocation),
        // );
      },
    );
  }

  Future<void> _onPressPinLocationButton() async {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        //   Prediction prediction = isFromLocation
        //       ? context.read<GoogleMapBloc>().currentSelectedFromPrediction
        //       : context.read<GoogleMapBloc>().currentSelectedToPrediction;
        //
        //   if (prediction.description == 'Tìm điểm đến...' ||
        //       prediction.description == 'Tìm điểm đi...') {
        //     context.read<GoogleMapBloc>().add(
        //           OnLoadDefaultLocationEvent(
        //             isFromLocation,
        //             currentLatLng,
        //           ),
        //         );
        //   } else {
        //     LatLng latLng = isFromLocation
        //         ? context
        //             .read<GoogleMapBloc>()
        //             .currentSelectedFromPointLatLng!
        //             .toLatLng
        //         : context
        //             .read<GoogleMapBloc>()
        //             .currentSelectedToPointLatLng!
        //             .toLatLng;
        //
        //     _addMarkerAndAnimateCameraToPosition(
        //       latLng: latLng
        //     );
        //
        //     debugPrint('Location: ${prediction.description}');
        //     debugPrint(
        //         'ID: ${isFromLocation == true ? 'From Location' : 'To Location'}');
        //     debugPrint('latitude: ${latLng.latitude}');
        //     debugPrint('longitude: ${latLng.longitude}');
        //   }
      },
    );
  }

  void _animateCameraToPosition(LatLng latLng) async {
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 14,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  void _addMarkerOnMap({required LatLng latLng}) async {
    setState(() {
      _markerList.add(
        Marker(
          markerId: MarkerId('My Location'),
          position: latLng,
          infoWindow: const InfoWindow(
            title: 'Searching Location',
          ),
        ),
      );
    });
  }

  void _addMarkerAndAnimateCameraToPosition({required LatLng latLng}) async {
    _addMarkerOnMap(latLng: latLng);

    _animateCameraToPosition(latLng);
  }

  void _showDirection({
    required PointLatLng start,
    required PointLatLng end,
    Prediction? startPre,
    Prediction? endPre,
    bool needMessage = true,
  }) async {
    // Generating the list of coordinates to be used for drawing the polylines
    // PolylineResult result = PolylineResult();

    // context.read<GoogleMapBloc>().add(
    //       OnCalculateDistanceEvent(start.toLatLng, end.toLatLng),
    //     );

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey, // Google Maps API Key
      start,
      end,
      travelMode: flutter_polyline_points.TravelMode.transit,
    );

    setState(() {
      // Adding the coordinates to the list
      if (result.points.isNotEmpty) {
        debugPrint('Point list has ${result.points.length} points');

        for (var point in result.points) {
          debugPrint('${point.longitude}, ${point.latitude}');

          polylineLatLngList.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        debugPrint('Point list is empty');
      }

      // Defining an ID
      PolylineId id = const PolylineId('poly');

      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineLatLngList,
        width: 4,
      );

      // Adding the polyline to the map
      polylinesMap[id] = polyline;
    });
  }

  void _comeBack() {
    context.router.pop();
  }

  @override
  void initState() {
    _getUserCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _comeBack,
          color: Colors.white,
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30.size,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        leadingWidth: 40.width,
        toolbarHeight: 100.height,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "US Buildings",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            _searchingButton(),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: _kGoogle,
              markers: Set<Marker>.of(_markerList),
              mapType: MapType.terrain,
              myLocationEnabled: true,
              polylines: Set<Polyline>.of(polylinesMap.values),
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20.width,
            child: GradientElevatedButton(
              text: 'Xác nhận địa chỉ',
              buttonWidth: MediaQuery.of(context).size.width - 40.width,
              buttonHeight: 50.height,
              beginColor: Theme.of(context).colorScheme.primary,
              endColor: Theme.of(context).colorScheme.primary,
              buttonMargin: EdgeInsets.symmetric(
                vertical: 30.height,
              ),
              onPress: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchingButton() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _onPressTextBox(),
            child: Container(
              margin: EdgeInsets.only(top: 10.height),
              padding: EdgeInsets.symmetric(
                vertical: 10.height,
                horizontal: 5.width,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.radius),
              ),
              child: BlocConsumer<GoogleMapBloc, GoogleMapState>(
                listener: (context, state) async {},
                builder: (context, state) {
                  String? currentLocation = context
                      .read<GoogleMapBloc>()
                      .currentSelectedPrediction
                      .description;

                  return Text(
                    currentLocation ?? '---',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.size,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(
          width: 35.size,
          height: 35.size,
          child: IconButton(
            onPressed: _onPressRemoveLocationButton,
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        SizedBox(
          width: 35.size,
          height: 35.size,
          child: IconButton(
            onPressed: _onPressPinLocationButton,
            icon: Icon(
              Icons.pin_drop_sharp,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
