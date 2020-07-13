import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:parkIt/components/base_component.dart';
import 'package:parkIt/models/reservation.model.dart';
import 'package:parkIt/services/reservation_service.dart';
import 'package:rxdart/rxdart.dart';

import '../locator.dart';

class BookedComponent extends BaseComponent {
  //========================== Services =========================//
  ReservationService reservationService = locator.get<ReservationService>();

  //========================= Controllers ======================//
  BehaviorSubject _reservationController = BehaviorSubject<Reservation>();

  //======================== Streams ==========================//
  Stream get reservation$ => _reservationController.stream;
  //======================== Sinks  ==========================//
  StreamSink<Reservation> get reservation => _reservationController.sink;
  //======================= Getters & Setters  ================//

  //======================= Component onInit =====================//

  BookedComponent() {}

  //======================= Methods =======================//

  getReservation(String e) {
    print("get reservation");
    if (e.length > 0)
      this.reservationService.getReservation(e).listen((event) {
        _reservationController.add(event);
      });
  }

  //======================= dispose =======================//
  @override
  void dispose() {
    _reservationController?.close();
  }
}
