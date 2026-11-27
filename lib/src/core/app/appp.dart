import 'package:dasturnomi/src/core/router/app_router.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin panel',
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppPages.home,
    );
  }
}
