
import 'package:geocoding/geocoding.dart' show placemarkFromCoordinates, Placemark;
import 'package:geolocator/geolocator.dart';

/// Class for handling location related operations.
class LocationRepository {

  /// Get current position
  Future<Position> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    /// Check if location permission is denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    /// Check if location permission is denied forever
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever');
    }

    /// Set location settings
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    /// Fetch location
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings
    );
  }

  /// Convert coordinates to readable place name
  Future<String> getPlaceNameFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);

    /// Check if no address found
    if (placemarks.isEmpty) {
      throw Exception('No address found');
    }

    final place = placemarks.first;

    return _buildReadablePlaceName(place);
  }

  /// Build readable place name from Placemark 
  String _buildReadablePlaceName(Placemark p) {
    return [
      p.locality,            // city/ward
      p.subLocality,         // area/neighborhood
      p.administrativeArea,  // prefecture/state
      p.country,             // country
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  }
}
