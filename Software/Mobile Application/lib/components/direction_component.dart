import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parkIt/components/base_component.dart';
import 'package:parkIt/locator.dart';
import 'package:parkIt/models/directions.model.dart';
import 'package:parkIt/services/map_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:parkIt/models/parking.model.dart';
import 'package:parkIt/services/parking_service.dart';

class DirectionComponent extends BaseComponent {
  //========================== Services =========================//
  ParkingService parkingService = locator.get<ParkingService>();

  MapService mapService = locator.get<MapService>();

  Location _locationService = locator<Location>();

  //========================= Controllers ======================//
  final _parkingController = BehaviorSubject<Parking>();

  //======================== Streams ==========================//
  Stream get parking$ => _parkingController.stream;

  //======================== Sinks  ==========================//

  StreamSink<Parking> get parking => _parkingController.sink;

  //======================= Getters & Setters  ================//
  // map
  GoogleMapController _mapController;

  // current location
  static LatLng _initialPosition;
  LatLng get initialPosition => _initialPosition;

  // markers
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  // directions items
  DirectionsItems _directionsItems = DirectionsItems();
  DirectionsItems get directionsItems => _directionsItems;

  // ploylines
  final Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;

  //======================= Component onInit =====================//

  DirectionComponent() {
    getLocation();
  }

  //======================= Methods =======================//

  loadParking(String id) {
    print(id);
    this.parkingService.getParking(id).listen((event) {
      print("load parking data");
      parking.add(event);
      print("add marker");
      addMarker(event);
    });
  }

  // method for adding a marker
  void addMarker(Parking p) {
    LatLng position = LatLng(p.coordinate.latitude, p.coordinate.longitude);
    _markers.add(Marker(
        markerId: MarkerId(p.name),
        position: position,
        infoWindow: InfoWindow(title: p.name, snippet: "Description"),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)));
  }

  // method for updating the mapController
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // getting user current location
  Future<void> getLocation() async {
    LocationData location;

    _locationService.changeSettings(accuracy: LocationAccuracy.high);

    location = await _locationService.getLocation();

    _initialPosition = LatLng(location.latitude, location.longitude);
  }

  // method for moving camera to the new bounds area
  void _moveCamera(LatLngBounds bounds) {
    if (_markers.length > 0) {
      try {
        _mapController.moveCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }
  }

  Future calcRoute(Parking p) async {
    // destination
    LatLng position = LatLng(p.coordinate.latitude, p.coordinate.longitude);

    // Retrieve the start and end locations and create
    // a DirectionsRequest using driving directions.
    _directionsItems =
        await this.mapService.getRouteCoordinates(position, _initialPosition);

    p.duration = directionsItems.duration;
    p.address = directionsItems.startaddress;

    // move the camera two fit both the source and destination
    _moveCamera(directionsItems.bounds);

    // drawing the route
    _DrawPolyline(directionsItems.polyline);

    notifyListeners();
  }

  // method for adding points to the polyline list
  void _DrawPolyline(String encodedPoly) {
    _polylines.clear();
    _polylines.add(Polyline(
      polylineId: PolylineId(_initialPosition.toString()),
      width: 9,
      points: _convertToLatLng(_decodePoly(encodedPoly)),
      color: Colors.redAccent,
      visible: true,
    ));

    notifyListeners();
  }

  // converting the list of point from the polyline string to list a of LatLng points
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // poly decoder from google
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negative then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    //print(lList.toString());

    return lList;
  }

  //======================= dispose =======================//

  void dispose() {
    _parkingController?.close();
  }
}
