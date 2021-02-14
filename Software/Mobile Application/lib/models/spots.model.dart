class Spot {
  final String key;
  bool occupied;
  bool reserved;
  String reservationNumber;

  Spot({this.key, this.occupied, this.reserved, this.reservationNumber});

  factory Spot.fromMap(data, key) {
    return Spot(
        key: key,
        occupied: data['occupied'] ?? false,
        reserved: data['reserved'] ?? false,
        reservationNumber: data['reservation_number'] ?? "");
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['reserved'] = this.reserved;
    data['occupied'] = this.occupied;
    data["reservationNumber"] = this.reservationNumber;
    return data;
  }
}
