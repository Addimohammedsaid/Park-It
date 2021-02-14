import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkIt/keys.dart';
import 'package:parkIt/models/directions.model.dart';
import 'package:parkIt/models/step.model.dart';

import 'networking_service.dart';

class MapService {
  Future<DirectionsItems> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String apiKey = API_KEY;

    String mode = "driving";

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&mode=$mode&key=$apiKey";

    print(url);

    Data data = Data(url);

    DirectionsItems directionItem = DirectionsItems();

    try {
      var routeData = await data.getData();

      // Get The polyline from the API :
      directionItem.polyline =
          routeData["routes"][0]["overview_polyline"]["points"];

      // Get the bounds from the API :
      LatLng s, n;
      double lat, lng;
      var boundsData = routeData['routes'][0]['bounds'];

      lat = boundsData['northeast']['lat'];
      lng = boundsData['northeast']['lng'];
      n = LatLng(lat, lng);

      lat = boundsData['southwest']['lat'];
      lng = boundsData['southwest']['lng'];
      s = LatLng(lat, lng);

      directionItem.bounds = LatLngBounds(southwest: s, northeast: n);

      // Get the Legs from the API :
      var legsData = routeData["routes"][0]["legs"][0];

      directionItem.startAddress = LatLng(
          legsData["start_location"]["lat"], legsData["start_location"]["lng"]);

      directionItem.endAddress = LatLng(
          legsData["end_location"]["lat"], legsData["end_location"]["lng"]);

      directionItem.distance = legsData["distance"]["text"];

      directionItem.duration = legsData["duration"]["text"];

      directionItem.htmlInstruction = popHtml(
          routeData["routes"][0]["legs"][0]["steps"][0]["html_instructions"]);

      directionItem.startaddress = legsData["start_address"];

      // Get the Steps from the API :
      var stepsData = routeData["routes"][0]["legs"][0]["steps"] as List;

      for (var step in stepsData) {
        var d = StepItem(
          duration: step["duration"]["text"],
          distance: step["distance"]["text"],
          endLocation:
              LatLng(step["end_location"]["lat"], step["end_location"]["lat"]),
          startLocation: LatLng(
              step["start_location"]["lat"], step["start_location"]["lng"]),
          htmlInstruction: popHtml(step["html_instructions"]),
        );
        directionItem.steps.add(d);
      }

      // return everything in one single object
      return directionItem;
    } catch (e) {
      print("The Following is an erreur from DirectionsServices class :");
      print(e);
      return null;
    }
  }

  String popHtml(String value) {
    value = value.replaceAll("<b>", "");
    value = value.replaceAll("</b>", "");
    return value;
  }
}
