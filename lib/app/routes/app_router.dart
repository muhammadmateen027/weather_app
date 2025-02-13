import 'package:flutter/material.dart';

import '../../pages/pages.dart';

class AppRouter {
  const AppRouter._();

  // Route names as static constants
  static const String initial = '/';
  static const String citySearch = '/citySearch';
  static const String settings = '/settings';

  // Enhanced route generator with type safety
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => _buildPage(settings.name),
    );
  }

  // Helper method to build pages
  static Widget _buildPage(String? routeName) {
    switch (routeName) {
      case initial:
        return const WeatherPage();
      case citySearch:
        return SearchPage();
      case settings:
        return const SettingsPage();
      default:
        return const WeatherPage(); // Could also show a 404 page here
    }
  }
}

// Navigation helper methods
extension NavigatorExtension on BuildContext {
  void navigateToSearch() => _navigateToRoute(AppRouter.citySearch);

  void navigateToSettings() => _navigateToRoute(AppRouter.settings);

  void _navigateToRoute(String route) => Navigator.pushNamed(this, route);
}
