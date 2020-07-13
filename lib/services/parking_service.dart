import 'package:firebase_database/firebase_database.dart';
import 'package:parkIt/models/parking.model.dart';

class ParkingService {
  ParkingService() {
    print("init parking service");
  }

  // reference to Parkings
  final databaseRealtimeParking =
      FirebaseDatabase.instance.reference().child('parkings');

  // get parking
  Stream<Parking> getParking(String uid) {
    return this.databaseRealtimeParking.child(uid).onValue.map(
        (event) => Parking.fromMap(event.snapshot.value, event.snapshot.key));
  }

  // set parking spot
  Future setSpotReserved(String parking, String spot, bool state) async {
    return await this
        .databaseRealtimeParking
        .child(parking)
        .child("spots")
        .child(spot)
        .update({"reserved": state});
  }

  // Get list parkings data stream
  Stream<List<Parking>> get parkings {
    return databaseRealtimeParking.onValue.map((e) {
      return _parkingListFromSnapshot(e.snapshot);
    });
  }

  // get list parking from map
  List<Parking> _parkingListFromSnapshot(DataSnapshot snapshot) {
    List<Parking> list = [];
    var data = snapshot.value;
    for (var k in data.keys) {
      list.add(Parking.fromMap(data[k], k));
    }
    return list;
  }
}
