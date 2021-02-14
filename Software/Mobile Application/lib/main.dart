import 'package:flutter/material.dart';
import 'package:parkIt/locator.dart';
import 'package:parkIt/services/navigation_service.dart';
import 'package:parkIt/utils/size_config.dart';
import 'utils/app_theme.dart';
import 'utils/router.dart';

void main() async {
  // init getIt
  setupLocator();
  // Testing the responsive using Device Preview
  runApp(LayoutBuilder(builder: (context, constraints) {
    // Orientation Builder get the portrait or landscape view
    return OrientationBuilder(builder: (context, orientation) {
      // passe both constraints & the orientation to the sizeConfig Class and build all the logic there
      SizeConfig().init(constraints, orientation);
      return MyApp();
    });
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => Navigator(
        onGenerateRoute: (settings) =>
            MaterialPageRoute(builder: (context) => child),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      title: 'ParkIt App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: "/",
      onGenerateRoute: Router.generateRoute,
    );
  }
}
