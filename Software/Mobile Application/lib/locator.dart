import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:parkIt/components/direction_component.dart';
import 'package:parkIt/components/fill_information_component.dart';
import 'package:parkIt/components/home_component.dart';
import 'package:parkIt/components/user_component.dart';
import 'package:parkIt/services/authenification_service.dart';
import 'package:parkIt/services/map_service.dart';
import 'package:parkIt/services/navigation_service.dart';
import 'package:parkIt/services/parking_service.dart';
import 'package:parkIt/services/reservation_service.dart';
import 'package:parkIt/services/user_service.dart';

import 'components/booked_component.dart';
import 'components/reservation_component.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // services
  locator.registerLazySingleton(() => Location());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ParkingService());
  locator.registerLazySingleton(() => MapService());
  locator.registerLazySingleton(() => ReservationService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => NavigationService());

  // components
  locator.registerFactory(() => HomeComponent());
  locator.registerFactory(() => DirectionComponent());
  locator.registerFactory(() => ReservationComponent());
  locator.registerFactory(() => FillInformationComponent());
  locator.registerFactory(() => BookedComponent());
  locator.registerFactory(() => UserComponent());
}
