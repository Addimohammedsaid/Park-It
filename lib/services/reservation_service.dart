import 'package:firebase_database/firebase_database.dart';
import 'package:parkIt/models/reservation.model.dart';

class ReservationService {
  // reservation object
  Reservation reservation = Reservation();

  // reference to Reservation
  final databaseRealtimeReservation =
      FirebaseDatabase.instance.reference().child('reservations');

  Future createReservation() async {
    return await databaseRealtimeReservation
        .child(reservation.key)
        .set(this.reservation.toMap());
  }

  Stream<Reservation> getReservation(String reservation) {
    return this
        .databaseRealtimeReservation
        .child(reservation)
        .onValue
        .map((event) => Reservation.fromMap(event.snapshot.value));
  }
}
