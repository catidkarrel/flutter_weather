class FavoriteLocation {
  FavoriteLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory FavoriteLocation.fromJson(Map<String, dynamic> json) {
    return FavoriteLocation(
      name: json['name'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  final String name;
  final String latitude;
  final String longitude;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
