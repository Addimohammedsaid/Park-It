import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parkIt/components/home_component.dart';
import 'package:parkIt/views/base_view.dart';
import 'package:parkIt/widgets/loading.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeComponent>(
      onComponentReady: (component) {
        component.context = context;
        component.loadParkings();
      },
      builder: (context, component, child) => Scaffold(
          body: SafeArea(
              child: StreamBuilder<LocationData>(
                  stream: component.location.onLocationChanged,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Loading();
                    else
                      return GoogleMap(
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              snapshot.data.latitude, snapshot.data.longitude),
                          zoom: 14.4746,
                        ),
                        onMapCreated: component.onCreated,
                        markers: component.markers,
                      );
                  }))),
    );
  }
}
