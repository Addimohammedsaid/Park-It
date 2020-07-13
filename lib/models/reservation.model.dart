class Reservation {
  String key;
  int endTime;
  int startTime;
  double price;
  bool entered;
  String spot;
  String parking;
  String userId;
  String name;

  Reservation(
      {this.endTime,
      this.entered,
      this.key,
      this.name,
      this.price,
      this.parking,
      this.spot,
      this.startTime,
      this.userId});

  Map<String, dynamic> toMap() {
    return {
      'key': this.key ?? "",
      'startTime': this.startTime ?? 0,
      'endTime': this.endTime ?? 0,
      'price': this.price ?? 0.0,
      'name': this.name ?? "",
      'parking': this.parking ?? "",
      'spot': this.spot ?? "",
      'userId': this.userId ?? "",
    };
  }

  factory Reservation.fromMap(Map data) {
    data = data ?? {};
    return Reservation(
        endTime: data['endTime'] ?? 0,
        entered: data['entered'] ?? false,
        name: data['name'] ?? '',
        parking: data['parking'] ?? '',
        spot: data['spot'] ?? '',
        startTime: data['startTime'] ?? 0,
        price: data['price'] ?? 0.0,
        userId: data['userId'] ?? '');
  }
}
