import 'package:google_maps_flutter/google_maps_flutter.dart';

class StepItem {
  final LatLng startLocation;
  final LatLng endLocation;
  final String distance;
  final String duration;
  final String htmlInstruction;

  StepItem(
      {this.startLocation,
      this.distance,
      this.duration,
      this.endLocation,
      this.htmlInstruction});
}
