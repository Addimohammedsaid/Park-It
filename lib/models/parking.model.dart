import 'coordinate.model.dart';
import 'spots.model.dart';

class Parking {
  String key;
  String name;
  Coordinate coordinate;
  String address;
  String duration;
  int currentPrice;
  int totalEmpty;
  int totalReserved;
  List<Spot> spots;

  Parking(
      {this.name,
      this.key,
      this.totalReserved,
      this.totalEmpty,
      this.address,
      this.currentPrice,
      this.coordinate,
      this.spots,
      this.duration});

  factory Parking.fromMap(data, key) {
    data = data ?? {};
    return Parking(
      key: key,
      name: data["name"] ?? " ",
      address: data['address'],
      totalEmpty: data["total_empty"],
      totalReserved: data["total_reserved"],
      coordinate: Coordinate.fromMap(data['coordinate']),
      spots: _listFromSpots(data["spots"]) ?? [],
    );
  }

  static List<Spot> _listFromSpots(Map data) {
    List<Spot> spots = [];
    data = data ?? {};
    data.forEach((key, value) {
      if (value['reserved'] == false) spots.add(Spot.fromMap(value, key));
    });
    return spots;
  }
}
