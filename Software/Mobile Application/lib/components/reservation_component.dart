import 'dart:async';
import 'package:parkIt/components/base_component.dart';
import 'package:parkIt/locator.dart';
import 'package:parkIt/models/parking.model.dart';
import 'package:parkIt/services/parking_service.dart';
import 'package:parkIt/services/reservation_service.dart';
import 'package:rxdart/rxdart.dart';

class ReservationComponent extends BaseComponent {
  //========================== Services =========================//
  ParkingService parkingService = locator.get<ParkingService>();

  ReservationService reservationService = locator.get<ReservationService>();

  //========================= Controllers ======================//
  final _parkingController = BehaviorSubject<Parking>();
  final _endTimeController = BehaviorSubject<DateTime>();

  //======================== Streams ==========================//
  Stream get parking$ => _parkingController.stream;
  Stream get endTime$ => _endTimeController.stream.transform(endTimeValidator);

  //======================== Sinks  ==========================//

  StreamSink<Parking> get parking => _parkingController.sink;
  StreamSink<DateTime> get endTime => _endTimeController.sink;

  //======================= Getters & Setters  ================//

  // price
  // cost per minute
  static const double cpm = 3.33;
  static double _price;
  double get price => _price;

  // error handling
  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  //======================= Component onInit =====================//

  ReservationComponent() {}

  //======================= Methods =======================//

  loadParking(String id) {
    print(id);
    this.parkingService.getParking(id).listen((event) {
      print("load parking data");
      parking.add(event);
    });
  }

  // approximate cost of reservation
  double getPrice() {
    if (_endTimeController.value == null) return 0;
    var difference = _endTimeController.value.difference(DateTime.now());
    _price = (cpm * difference.inMinutes).roundToDouble();
    return _price;
  }

  //save to reservation service
  save() {
    this.reservationService.reservation.endTime =
        _endTimeController.value.millisecondsSinceEpoch;
    this.reservationService.reservation.price = _price;
    this.reservationService.reservation.parking = _parkingController.value.key;
  }

  //reserve
  Future<bool> reserve() async {
    try {
      this.reservationService.reservation.spot =
          _parkingController.value.spots[0].key;

      // create the reservation in database
      await this.reservationService.createReservation();

      // set the spot to reserved
      await this.parkingService.setSpotReserved(
          this.reservationService.reservation.parking,
          this.reservationService.reservation.spot,
          true);

      // no error return true
      return true;

      // error return false
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  //============================= Validator ======================//
  var endTimeValidator = StreamTransformer<DateTime, DateTime>.fromHandlers(
      handleData: (endTime, sink) {
    if (endTime.difference(DateTime.now()).inMinutes > 5)
      sink.add(endTime);
    else {
      sink.addError("Time must be greater(>) then 5 minutes");
    }
  });

  //======================= dispose =======================//
  @override
  void dispose() {
    print("dispose");
    _parkingController?.close();
    _endTimeController?.close();
  }
}
