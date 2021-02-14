import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'step.model.dart';

class DirectionsItems {
  DirectionsItems(
      {this.name,
      this.bounds,
      this.htmlInstruction,
      this.distance,
      this.polyline,
      this.duration,
      this.endAddress,
      this.startAddress,
      this.startaddress});

  String name;
  LatLng startAddress;
  LatLng endAddress;

  String htmlInstruction;

  LatLngBounds bounds;

  String distance;
  String duration;

  String startaddress;

  String polyline;

  List<StepItem> steps = List<StepItem>();
}
