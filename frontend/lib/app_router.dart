import 'package:flutter/material.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/anomalies_screen.dart';
import 'screens/admin/detail_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/anomalies':
        return MaterialPageRoute(builder: (_) => const AnomaliesScreen());
      case '/detail':
        final numDossier = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(numDossier: numDossier),
        );
      default:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
    }
  }
}