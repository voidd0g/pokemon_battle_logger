import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/views/home/home.view.dart';

class AppRouting {
  static const String home = '/home';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageRouteBuilder(
          settings: RouteSettings(
            name: home,
            arguments: settings.arguments,
          ),
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              const HomeView(),
          transitionDuration: Duration.zero,
        );
      case home:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              const HomeView(),
          transitionDuration: Duration.zero,
        );
      default:
        throw Exception('[AppRouting] Route not found');
    }
  }
}
