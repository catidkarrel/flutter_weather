class Location {
  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.region,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? region;
}
