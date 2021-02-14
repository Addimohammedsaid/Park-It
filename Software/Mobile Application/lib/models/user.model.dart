class User {
  final String uid;
  final String name;
  final String licensePlate;
  final int reservationNumber;
  final double wallet;

  User(
      {this.uid,
      this.name,
      this.licensePlate,
      this.wallet,
      this.reservationNumber});

  User.initial()
      : uid = '',
        name = '',
        wallet = 0.0,
        reservationNumber = 0,
        licensePlate = '';

  factory User.fromMap(data, uid) {
    data = data ?? {};
    return User(
        uid: uid,
        name: data["name"] ?? "",
        wallet: data["wallet"] ?? 0.0,
        reservationNumber: data["reservationNumber"] ?? 0,
        licensePlate: data["licensePlate"] ?? "");
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['licensePlate'] = this.licensePlate;
    data["wallet"] = this.wallet;
    data["reservation_number"] = this.wallet;
    return data;
  }
}
