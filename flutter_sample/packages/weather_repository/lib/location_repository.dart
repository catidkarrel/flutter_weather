
import 'package:geocoding/geocoding.dart' show placemarkFromCoordinates, Placemark;
import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Future<Position> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever');
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    // fetch location
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings
    );
  }

  // Convert coordinates to readable place name
  Future<String> getPlaceNameFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) {
      throw Exception('No address found');
    }

    final place = placemarks.first;

    return _buildReadablePlaceName(place);
  }

  String _buildReadablePlaceName(Placemark p) {
    return [
      p.locality,            // city/ward
      p.subLocality,         // area/neighborhood
      p.administrativeArea,  // prefecture/state
      p.country,             // country
    ].where((e) => e != null && e!.isNotEmpty).join(', ');
  }
}
