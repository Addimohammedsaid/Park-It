class Coordinate {
  final double latitude;
  final double longitude;
  Coordinate({this.latitude, this.longitude});

  factory Coordinate.fromMap(data) {
    data = data ?? {};
    return Coordinate(
      latitude: data["lat"] ?? 0.0,
      longitude: data["long"] ?? 0.0,
    );
  }
}
