import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parkIt/components/direction_component.dart';
import 'package:parkIt/models/parking.model.dart';
import 'package:parkIt/widgets/loading.dart';

import '../locator.dart';
import 'base_view.dart';

class DirectionView extends StatelessWidget {
  final Parking parking;

  DirectionView({this.parking});

  final location = locator.get<Location>();

  @override
  Widget build(BuildContext context) {
    return BaseView<DirectionComponent>(
      onComponentReady: (component) async {
        component.parking.add(parking);
        component.addMarker(parking);
        component.calcRoute(parking);
      },
      builder: (
        context,
        component,
        child,
      ) =>
          Scaffold(
              body: SafeArea(
                  child: StreamBuilder<LocationData>(
                      stream: location.onLocationChanged,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Loading();
                        } else
                          return GoogleMap(
                            myLocationEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(snapshot.data.latitude,
                                  snapshot.data.longitude),
                              zoom: 14.4746,
                            ),
                            onMapCreated: component.onCreated,
                            markers: component.markers,
                            polylines: component.polylines,
                          );
                      }))),
    );
  }
}
