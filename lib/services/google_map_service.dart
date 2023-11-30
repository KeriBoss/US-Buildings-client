import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapService {
  static Future<Location?> getLocationFromAddress(String address) async {
    try {
      List<Location> locationList = await locationFromAddress(address);

      return locationList.isNotEmpty ? locationList.first : null;
    } catch (e, stackTrace) {
      debugPrint(
        'Caught getting location from address error: ${e.toString()}\n${stackTrace.toString()}',
      );
      return null;
    }
  }

  static Future<String?> getAddressFromLocation(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      return placemarks.isNotEmpty
          ? generateCompleteAddress(placemarks.first)
          : null;
    } catch (e, stackTrace) {
      debugPrint(
        'Caught getting address from location error: ${e.toString()}\n${stackTrace.toString()}',
      );
      return null;
    }
  }

  static String generateCompleteAddress(Placemark placemark) {
    return '${placemark.street}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';
  }
}
