import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parkIt/components/base_component.dart';
import 'package:parkIt/services/navigation_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:parkIt/models/parking.model.dart';
import 'package:parkIt/services/parking_service.dart';

import '../locator.dart';

class HomeComponent extends BaseComponent {
  //========================== Services =========================//
  ParkingService parkingService = locator.get<ParkingService>();

  NavigationService navigationService = locator.get<NavigationService>();

  final location = locator.get<Location>();

  //========================= Controllers ======================//

  final _parkingListController = BehaviorSubject<List<Parking>>();

  //======================== Streams ==========================//
  Stream get parkingList$ => _parkingListController.stream;

  //======================== Sinks  ==========================//

  StreamSink<List<Parking>> get parkingList => _parkingListController.sink;

  //======================= Getters & Setters  ================//
  // map
  GoogleMapController _mapController;

  // markers
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  // UI
  BuildContext _context;

  set context(context) {
    _context = context;
  }

  //======================= Component onInit =====================//

  HomeComponent() {}

  //======================= Methods =======================//

  loadParkings() {
    this.parkingService.parkings.listen((event) {
      print("load parkings data");
      _parkingListController.add(event);
      loadMarkers();
    });
  }

  loadMarkers() {
    _markers.clear();
    print("load markers");
    _parkingListController.value.forEach((parking) {
      addMarker(parking);
    });
    notifyListeners();
  }

  // method for adding a marker
  void addMarker(Parking p) {
    bool spotAvailable = p.spots.length > 0;

    LatLng position = LatLng(p.coordinate.latitude, p.coordinate.longitude);
    _markers.add(Marker(
        onTap: () {
          if (spotAvailable)
            navigationService.navigateTo("/reservation", arguments: p);
        },
        markerId: MarkerId(p.name),
        position: position,
        infoWindow: InfoWindow(title: p.name, snippet: "Description"),
        icon: !spotAvailable
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen)));
  }

  // method for updating the mapController
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  //======================= dispose =======================//
  @override
  void dispose() {
    print("dispose");
    _parkingListController?.close();
  }
}
