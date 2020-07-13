import 'package:flutter/material.dart';
import 'package:parkIt/models/parking.model.dart';
import 'package:parkIt/views/auth/login_view.dart';
import 'package:parkIt/views/booked_view.dart';
import 'package:parkIt/views/direction_view.dart';
import 'package:parkIt/views/home_view.dart';
import 'package:parkIt/views/reservation/confirm_reservation_view.dart';
import 'package:parkIt/views/reservation/fill_information_view.dart';
import 'package:parkIt/views/reservation/reservation_view.dart';
import 'package:parkIt/views/user_dashboard_view.dart';
import 'package:parkIt/views/wrapper_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WrapperView());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView());
      case '/direction':
        var parking = settings.arguments as Parking;
        return MaterialPageRoute(
            builder: (_) => DirectionView(
                  parking: parking,
                ));
      case '/reservation':
        var parking = settings.arguments as Parking;
        return MaterialPageRoute(
            builder: (_) => ReservationView(
                  parking: parking,
                ));
      case '/fill':
        return MaterialPageRoute(builder: (_) => FillInformationView());
      case '/confirm':
        return MaterialPageRoute(builder: (_) => ConfirmReservationView());
      case '/booked':
        return MaterialPageRoute(builder: (_) => BookedView());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => UserDashboardView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
