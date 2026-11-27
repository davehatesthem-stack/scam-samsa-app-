import 'package:dasturnomi/src/features/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class AppPages {
  static const String home = '/home';
  static const String splash = '/splash';
}

class AppRouter {
    static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppPages.home:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text('Not found 404'))),
        );
    }
  }
}